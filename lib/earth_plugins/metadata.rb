# This class provide methods for managing any metadata for files
# The main functionality provided:
# 1- saving a file metadata
# 2- deleting a file(s) metadata
# Author:: Mohammad Bamogaddam

class Metadata < EarthPlugin
  #TODO abstract methods: 
  # 1- file_metadata(file), 
  # 2- create_metadata(file, attributes),
  
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
  def self.save_file_metadata(file)
    
    #delete any old metadata for this file
    self.delete_file_metadata(file)
    
    rspmeta = RspMetadata.new
    # extract metadata for the given file using another plug-in
    # TODO the used class to extract metadata could be changed to a passed parameter. so it will be more generic
    # TODO OR we could create the rsp_metadata (or any other metadata plug-ins) as subclass of this one
    # TODO and the method (file_metadata) defined here as abstract method(i.e. it should be implemented in any subclasses) 
    metadata = rspmeta.file_metadata(file)
    
    #bring the corresponding attribute Ids and types
    #create a array in the form: 
    # [{:attribute_id => ??, :attribute_type => ??, :value => ??}, {}, {},,,]
    metadata_with_att = metadata_with_attributes(metadata)
    
    # save file metdata
    for i in 0..metadata_with_att.size-1 do 
      #TODO (OLD, delete) file.metadata_key_value_pairs.create(:key => metadata.keys[i],  :value => metadata.values[i])
      
      #TODO use the abstract method create_metadata()
      file.metadata_strings.create(:value => metadata_with_att[i][:value], :metadata_attribute_id => metadata_with_att[i][:attribute_id])
    end
  end
  
  # the +delete_metadata+ method deletes any metadata associated with the passed file
  # === Parameters:
  # * _file_ = a file object which its metadata will be deleted 
  def self.delete_file_metadata(file)
    file.metadata_key_value_pairs.destroy_all unless file.nil? or file.metadata_key_value_pairs.empty?
  end
  
  # deletes all files_metadata for all files under a directory and its subdirectories
  # ===Parameters:
  # * _dir_ = a directory object which metadata for all files under it will be deleted 
  def self.delete_all_files_metadata_under_dir(dir)
    
    if dir.direct_children.size == 0
      delete_list_files_metadata(dir.files)
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
  def self.delete_list_files_metadata(files)
    for i in 0..files.size-1 do
      self.delete_file_metadata(files[i])
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
  
end
