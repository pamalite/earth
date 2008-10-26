#TODO class comments
# Author::Qing Yang & Mohammad Bamogaddam


class SearchByKVPairs < EarthPlugin
  
  # The +search_by(key,value)+ method is writen by QING Yang & Mohammad Bamogaddam
  
  # Both key and value are from the input of view, which are entered by users.
  # If key and value are not blank, we find out all the files which include the key and value pairs.
  # It means if we assume the key is "job" and the value is "A",then the method return all the files 
  # which have the key and value pairs like ("job","A").
    
  def self.search_by(key,value)
    result_set_files=Array.new   
    rsp_name=value
    rsp_name="*" if rsp_name.blank?
    
    rsp_key=key
    rsp_key="*" if rsp_key.blank?
    
    if rsp_name!="*"&& rsp_key!="*"
      
      #bring the attribute_id corresponds to the given key
      attribute = Earth::MetadataAttribute.find_by_name(key)
      
      mkvps=Earth::MetadataString.find(:all,:conditions=>
                                             ["metadata_attribute_id = ? and value LIKE ?",attribute.id,"%"+value+"%"])
      mkvps.each do |m|
        for file in m.files do
          result_set_files.push(file)
        end
      end
    end
    
    
    return result_set_files
    
  end
  
  
end
