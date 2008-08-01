# This class provide methods for managing any metadata for files
# The main functionality provided:
# 1- saving a file metadata
# 2- deleting a file(s) metadata
# Author:: Mohammad Bamogaddam, Ming

class Metadata < EarthPlugin
  
  
  # the +save_file_metadata+ save metadata for a given file
  # if there is already metdata for this file it will be deleted and the new ones will be saved
  # === Parameters:
  # * _file_ = a file object, represent a record in files table.
  #            this method will save metadata for this file
  # TODO we may create a new method to add metadata to the existing ones
  # TODO we may send the plug-in reference which should be used to extract metadata, currently use rsp_metadata
  def self.save_file_metadata(file)
    
    #delete any old metadata for this file
    self.delete_file_metadata(file)
    
    rspmeta = RspMetadata.new
    # extract metadata for the given file using another plug-in
    # TODO the used class to extract metadata could be changed to a passed parameter. so it will be more generic
    metadata = rspmeta.file_metadata(file)
          
    # save file metdata
    for i in 0..metadata.size-1 do      
      file.metadata_key_value_pairs.create(:key => metadata.keys[i],  :value => metadata.values[i])
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
  
end
