# This class TODO comments
#
# Author:: Mohammad Bamogaddam

class RspDeleteUnderDirMetadata < EarthPlugin
  
  # constant variable used to save rsp naming convention
  RSP_KEYS = ["job","sequence","shot"]
  
  # the +rsp_keys+ method returns array of rsp keys
  def self.rsp_keys
    RSP_KEYS
  end
  
  def self.plugin_name
    "EarthRspDeleteUnderDirMetadata"
  end

  def self.plugin_version
    2
  end
  
  def initialize
    # read the (file) parameter from the plugin session
    dir = get_param(:dir)
    unless dir.nil?
      EarthApi::MetadataApi.delete_all_files_metadata_under_dir(dir,RSP_KEYS)
    end
  end

end
