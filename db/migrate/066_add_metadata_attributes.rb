class AddMetadataAttributes < ActiveRecord::Migration
  def self.up
    Earth::MetadataAttribute.create :name => 'job', :metadata_type => 'string'
    Earth::MetadataAttribute.create :name => 'sequence', :metadata_type => 'string'
    Earth::MetadataAttribute.create :name => 'shot', :metadata_type => 'string'
  end

  def self.down
  end
end
