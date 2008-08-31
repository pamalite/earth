module Earth
  #TODO class comments
  class ExtensionPoint < ActiveRecord::Base
    belongs_to :plugin_descriptor
  end
end
