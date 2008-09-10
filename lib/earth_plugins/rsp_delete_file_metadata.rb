# This class TODO comments
#
# Author:: Mohammad Bamogaddam

class RspDeleteFileMetadata < EarthPlugin
  
  # constant variable used to save rsp naming convention
  RSP_KEYS = ["job","sequence","shot"]
  
  # the +rsp_keys+ method returns array of rsp keys
  def self.rsp_keys
    RSP_KEYS
  end
  
  def self.plugin_name
    "EarthRspDeleteFileMetadata"
  end

  def self.plugin_version
    2
  end
  
  def initialize
    # read the (file) parameter from the plugin session
    file = get_param(:file)
    unless file.nil?
      EarthApi::MetadataApi.delete_file_metadata(file, RSP_KEYS)
    end
  end

end
