# This class TODO comments
#
# Author:: Mohammad Bamogaddam

class RspAddFileMetadata < RspMetadata
  
  def self.plugin_name
    "EarthRspAddFileMetadata"
  end

  def self.plugin_version
    1
  end
  
  def initialize
    # read the (file) parameter from the plugin session
    file = get_param(:file)
    unless file.nil?
      save_file_metadata(file)
    end
  end

end
