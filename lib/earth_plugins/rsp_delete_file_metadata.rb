# This class TODO comments
#
# Author:: Mohammad Bamogaddam

class RspDeleteFileMetadata < RspMetadata
  
  def initialize
    # read the (file) parameter from the plugin session
    file = get_param(:file)
    unless file.nil?
      delete_file_metadata(file)
    end
  end

end
