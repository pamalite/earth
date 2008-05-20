# TODO: add class comments

class RspMetadata < EarthPlugin
  
  # TODO: add comments
  RspKeys = ["job","sequence","shot"]
  
  # TODO: add method comments
  def self.rsp_keys
    RspKeys
  end
  
  
  # TODO: add method comments
  def self.file_metadata(file)
    # Find the parent directory for the given file
    # TODO: catch any exception (record not found, etc)
    directory = Earth::Directory.find(file.directory_id)
    # save the path
    path = directory.path
    # parse the path, look for keys and save metadata
    metadata = parse_path(path)
    return metadata
  end
  
  # TODO: add method comments
  def self.search_by(key, value)
    
  end
  
  #TODO: make it private
  #private
  
  # TODO: add method comments
  # TODO: remove 'self'
  def self.parse_path(path)
    metadata = {}
    # split the path into tokens
    tokens = path.split('/')
    # loop all over the tokens looking for keys (or something similar to keys)
    tokens.each do |token|
      # find the index of the key (alike)
      index = match_one_of(RspKeys, token)
      if index >= 0
        # extract the value
        value = extract_value(RspKeys[index], token)
        # save key, value pairs
        metadata[RspKeys[index]] = value
      end
    end
    metadata
  end
  
  # TODO: add method comments
  # TODO: remove 'self'
  def self.match_one_of(keys, test)
    keys.each do |key|
      if test =~ Regexp.new(key)
        return keys.index(key)
      end
    end
    return -1
  end
  
  # TODO: add method comments
  # TODO: remove 'self'
  def self.extract_value(key, test)
    test.sub(Regexp.new(key), "")
  end
  
end
