module Earth
  #TODO class comments
  class ExtensionPoint < ActiveRecord::Base
    has_many :plugin_descriptors
  end
end
