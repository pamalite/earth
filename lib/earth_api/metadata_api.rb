module EarthApi
  #TODO class comments
  class MetadataApi
    # the +save_file_metadata+ save metadata for a given file
    # if there is already metdata for this file it will be deleted and the new ones will be saved
    # === Parameters:
    # * _file_ = a file object, represent a record in files table.
    #            this method will save metadata for this file
    # * _metadata_ = TODO
    # the metadata in a hash form: {key => value, key2 => value2,,,}
    # where: the (key) should corresponds to an attribute_name in metadata_attributes table
    # examples of metadata:
    # {"job" => "lor", "sequence" => "001", "shot" => "143"}
    # {"resolution" => 300}
    # {"file_type" => "JPG"}...etc
    def self.save_file_metadata(file, metadata)
      #delete any old metadata for this file
      # TODO
      attribute_names = metadata.keys
      delete_file_metadata(file, attribute_names)
      
      #bring the corresponding attribute Ids and types
      #create a array in the form: 
      # [{:attribute_id => ??, :attribute_type => ??, :value => ??}, {}, {},,,]
      metadata_with_att = metadata_with_attributes(metadata)                        
      
      # save file metdata
      for i in 0..metadata_with_att.size-1 do 
        #use the method create_metadata() 
        #create_metadata(file, {:value => metadata_with_att[i][:value], :metadata_attribute_id => metadata_with_att[i][:attribute_id]})
        create_metadata(file, metadata_with_att[i])
      end
    end
    
    
    #The +metadata_with_attributes+ method brings the corresponding attribute Ids and types
    #create a array in the form: 
    # [{:attribute_id => ??, :attribute_type => ??, :value => ??}, {}, {},,,]
    # === Parameters:
    # * _metadata_ = hash contains metadata in the form {key => value, key2, => value2,,,}
    # key = String should have an entry in the metadata_attributes
    # value = the metadata value
    def self.metadata_with_attributes(metadata)
      metadata_with_att = Array.new
      for i in 0..metadata.size-1 do
        attribute = Earth::MetadataAttribute.find_by_name(metadata.keys[i])
        unless attribute.nil?
          metadata_with_att << {:attribute_id => attribute.id, :attribute_type => attribute.metadata_type, :value => metadata.values[i]}
        end
      end
      metadata_with_att
    end
    
    # this method saves metadata on the needed table depending on its type
    # if metadata type is string, it will be saved in metadata_strings table
    # and so on
    # * _metadata_with_att_ = Hash in the form {:value => ??, :attribute_id => ??, :attribute_type => ??}
    def self.create_metadata(file , metadata_with_att)
      attributes = {:value => metadata_with_att[:value], :metadata_attribute_id => metadata_with_att[:attribute_id]}
      #check the metadata type to save it in the right table
      type = metadata_with_att[:attribute_type]
      if(type == "string")
        file.metadata_strings.create(attributes)
        #else if(type == "integer")
        #file.metadata_integers.create(attributes)
        #and so on
      end
    end
    
    # the +delete_metadata+ method deletes 
    # any metadata (with specified attribute names) associated with the passed file
    # === Parameters:
    # * _file_ = a file object which its metadata will be deleted
    # * _attribute_names_ = TODO
    def self.delete_file_metadata(file, attribute_names)
      
      for meta in metadata_values(file, attribute_names)
        meta_id = meta.id
        # delete the association records
        # TODO use the abstract method instead
        delete_join_records(file, meta)
        
        # if this metadata is not linked to any other files, delete it
        # otherwise, leave it
        #TODO OLD result = Earth::FilesMetadataString.find_by_metadata_string_id(meta_id)
        result = find_files_associated(meta)
        if result.nil?
          meta.destroy
        end
        
      end
    end
    
    #TODO comments
    def self.delete_join_records(file, meta)
      attribute = meta.metadata_attribute
      if(attribute.metadata_type == "string")
        Earth::FilesMetadataString.delete_all({:file_id => file.id, :metadata_string_id => meta.id})
        #else if(attribute.metadata_type == "integer")
        # ....Earth::FilesMetadataInteger.delete_all({:file_id => file.id, :metadata_string_id => meta.id})
        # and so on
      end
    end
    
    # deletes all files_metadata for all files under a directory and its subdirectories
    # ===Parameters:
    # * _dir_ = a directory object which metadata for all files under it will be deleted
    # * _attribute_names_ = TODO 
    def delete_all_files_metadata_under_dir(dir, attribute_names)
      if dir.direct_children.size == 0
        delete_list_files_metadata(dir.files, attribute_names)
        return
      end
      
      children = dir.direct_children
      
      for i in 0..children.size-1 do
        delete_all_files_metadata_under_dir(children[i])
      end
    end
    
    # the +delete_metadata+ method deletes any metadata associated with all files
    # === Parameters:
    # * _files_ = list of files. Their metadata will be deleted, one by one using the +delete_file_metadata+ method
    # * _attribute_names_ = TODO  
    def delete_list_files_metadata(files, attribute_names)
      for i in 0..files.size-1 do
        delete_file_metadata(files[i], attribute_names)
      end
    end
    
    #this method return metadata values for a given file and specified attribute names
    def self.metadata_values(file, attribute_names)
      result = []
      #retrieve attributes from their names
      attributes = Earth::MetadataAttribute.find(:all, :conditions => "name in " + for_sql(attribute_names)) 
      #now, bring the corrosponding metadata from each attribute linke with the passed file
      for att in attributes do
        if(att.metadata_type == "string")
          values = Earth::MetadataString.find(:all, :conditions => {:metadata_attribute_id => att.id})
          #else if(att.metadata_type =="integer")
          # ....values = Earth::FilesMetadataInteger.find(:all, :conditions => {:metadata_attribute_id => att.id})
          # and so on
        end
        # save the values which are associated with the passed file
        for v in values do
          if search_files(v.files, file.id)
            result << v
          end
        end
      end
      result
    end
    
    # TODO comments
    def self.find_files_associated(metadata)
      attribute = metadata.metadata_attribute
      if(attribute.metadata_type == "string")
        result = Earth::FilesMetadataString.find_by_metadata_string_id(metadata.id)
        #else if(attribute.metadata_type == "integer")
        #....result = Earth::FilesMetadataInteger.find_by_metadata_integer_id(metadata.id)
        #and so on
      end
      result
    end
    
    # prepare list of names to be used in sql statement
    def self.for_sql(attribute_names)
      new_att = []
      for att in attribute_names do
        new_att << "\'" + att + "\'"
      end
      "(" + new_att.join(",") + ")"
    end
    
    # TODO comments
    def self.search_files(files, target_id)
      for f in files do
        if f.id == target_id
          return true
        end
      end
      return false
    end
    
    
    
    
  end
end
