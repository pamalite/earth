# This class provide methods for managing any metadata for files
# The main functionality provided:
# 1- saving a file metadata
# 2- deleting a file(s) metadata
# Author:: Mohammad Bamogaddam

class Metadata < EarthPlugin
  #TODO abstract methods: 
  # 1- file_metadata(file) == extract metadata values from a given file. 
  #    this method is plug-in specific. each plug-in will have it is own algorithm for this method
  #    the importnat thing is the format of the returned metadata: it should be a Hash in the form: {key => value, key2 => value2,,,}
  #    where: the (key) should corresponds to an attribute_name in metadata_attributes table  
  # 2- create_metadata(file, attributes) == it is simple method -- file.metadata_strings.create(attributes)
  # 3- delete_join_records(file, metadata_value_id) == it is simple method -- Earth::FilesMetadataString.delete_all({:file_id => file.id, :metadata_string_id => metadata_value_id}) 
  # 4- metadata_values(file) --- it is as simple as --> file.metadata_strings
  # 5- find_by_metadata_value_id(id) -- searches the join table looking for records associated with some metadata
  #      -- it should be like -- Earth::FilesMetadataString.find_by_metadata_string_id()
  
  def file_metadata(file)
    raise NotImplementedError
  end
  
  def create_metadata(file , attributes)
    raise NotImplementedError
  end
  
  def delete_join_records(file, metadata_value_id)
    raise NotImplementedError
  end
  
  def metadata_values(file)
    raise NotImplementedError
  end
  
  def find_by_metadata_value_id(id)
    raise NotImplementedError
  end
  
  
  
  # the +save_file_metadata+ save metadata for a given file
  # if there is already metdata for this file it will be deleted and the new ones will be saved
  # === Parameters:
  # * _file_ = a file object, represent a record in files table.
  #            this method will save metadata for this file
  # TODO we may create a new method to add metadata to the existing ones
  # TODO we may send the plug-in reference which should be used to extract metadata, currently use rsp_metadata
  # TODO OR we could create the rsp_metadata (or any other metadata plug-ins) as subclass of this one
  # TODO and define the method (file_metadata) here as an abstract method(i.e. it should be implemented in any subclasses)
  # the plug-in should give the metadata in a hash form: {key => value, key2 => value2,,,}
  # where: the (key) should corresponds to an attribute_name in metadata_attributes table
  # examples of metadata:
  # {"job" => "lor", "sequence" => "001", "shot" => "143"}
  # {"resolution" => 300}
  # {"file_type" => "JPG"}...etc
  def save_file_metadata(file = nil)
    # read the (file) parameter from the plugin session
    f = get_param(:file)
    file = f unless f.nil?
    
    unless file.nil?
      #delete any old metadata for this file
      delete_file_metadata(file)
      
      
      # extract metadata for the given file using another plug-in
      # we create the rsp_metadata (or any other metadata plug-ins) as subclass of this one
      #  and the method (file_metadata) defined here as abstract method(i.e. it should be implemented in any subclasses) 
      metadata = file_metadata(file)
      
      #bring the corresponding attribute Ids and types
      #create a array in the form: 
      # [{:attribute_id => ??, :attribute_type => ??, :value => ??}, {}, {},,,]
      metadata_with_att = metadata_with_attributes(metadata)                        
      
      # save file metdata
      for i in 0..metadata_with_att.size-1 do 
        #use the abstract method create_metadata() 
        # OR TODO TRY 
        #  values = metadata_values
        #  metadata_values.create()
        # if this worked, no need for create_metadata() method
        create_metadata(file, {:value => metadata_with_att[i][:value], :metadata_attribute_id => metadata_with_att[i][:attribute_id]})
      end
    end
  end
  
  # the +delete_metadata+ method deletes any metadata associated with the passed file
  # === Parameters:
  # * _file_ = a file object which its metadata will be deleted
  def delete_file_metadata(file = nil)
    # read the (file) parameter from the plugin session
    f = get_param(:file)
    file = f unless f.nil?
    
    unless file.nil?
      for meta in metadata_values(file)
        meta_id = meta.id
        # delete the association records
        # TODO use the abstract method instead
        delete_join_records(file, meta_id)
        
        # if this metadata is not linked to any other files, delete it
        # otherwise, leave it
        #TODO OLD result = Earth::FilesMetadataString.find_by_metadata_string_id(meta_id)
        result = find_by_metadata_value_id(meta_id)
        if result.nil?
          meta.destroy
        end
        
      end
    end
  end
  
  # deletes all files_metadata for all files under a directory and its subdirectories
  # ===Parameters:
  # * _dir_ = a directory object which metadata for all files under it will be deleted 
  def delete_all_files_metadata_under_dir(dir = nil)
    # read the (dir) parameter from the plugin session
    d = get_param(:dir)
    dir = d unless d.nil?
    
    unless dir.nil?
      if dir.direct_children.size == 0
        delete_list_files_metadata(dir.files)
        return
      end
      
      children = dir.direct_children
      
      for i in 0..children.size-1 do
        delete_all_files_metadata_under_dir(children[i])
      end
    end
  end
  
  
  # the +delete_metadata+ method deletes any metadata associated with all files
  # === Parameters:
  # * _files_ = list of files. Their metadata will be deleted, one by one using the +delete_file_metadata+ method  
  def delete_list_files_metadata(files)
    for i in 0..files.size-1 do
      delete_file_metadata(files[i])
    end
  end
  
  
  private
  #The +metadata_with_attributes+ method brings the corresponding attribute Ids and types
  #create a array in the form: 
  # [{:attribute_id => ??, :attribute_type => ??, :value => ??}, {}, {},,,]
  # === Parameters:
  # * _metadata_ = hash contains metadata in the form {key => value, key2, => value2,,,}
  # key = String should have an entry in the metadata_attributes
  # value = the metadata value
  def metadata_with_attributes(metadata)
    metadata_with_att = Array.new
    for i in 0..metadata.size-1 do
      attribute = Earth::MetadataAttribute.find_by_name(metadata.keys[i])
      unless attribute.nil?
        metadata_with_att << {:attribute_id => attribute.id, :attribute_type => attribute.metadata_type, :value => metadata.values[i]}
      end
    end
    metadata_with_att
  end
  
  # TODO replaced by an abstract method
  #def self.delete_join_records(file, metadata_value_id)
  #  Earth::FilesMetadataString.delete_all({:file_id => file.id, :metadata_string_id => metadata_value_id})
  #end
  
end
