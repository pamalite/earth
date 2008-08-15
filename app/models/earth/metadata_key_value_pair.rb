module Earth
class MetadataKeyValuePair < ActiveRecord::Base
  belongs_to :file
end
end
