# This class TODO comments
#
# Author:: Mohammad Bamogaddam

class RspDeleteUnderDirMetadata < RspMetadata
  
  def self.plugin_name
    "EarthRspDeleteUnderDirMetadata"
  end

  def self.plugin_version
    1
  end
  
  def initialize
    # read the (file) parameter from the plugin session
    dir = get_param(:dir)
    unless dir.nil?
      delete_all_files_metadata_under_dir(dir)
    end
  end

end
