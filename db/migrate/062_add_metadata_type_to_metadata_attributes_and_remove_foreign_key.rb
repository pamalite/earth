class AddMetadataTypeToMetadataAttributesAndRemoveForeignKey < ActiveRecord::Migration
  def self.up
    add_column :metadata_attributes, :metadata_type, :string
    #OLD stuff. was for testing metadata_attributes table
    #change_column :metadata_attributes, :plugin_descriptor_id, :integer , :null => true
    #remove_foreign_key :metadata_attributes, :metadata_attribute_plugin_descriptor_id_fk
  end

  def self.down
    remove_column :metadata_attributes, :metadata_type
    
    
    #OLD stuff. was for testing metadata_attributes table
    #change_column :metadata_attributes, :plugin_descriptor_id, :integer , :null => false
    #add_foreign_key :metadata_attributes, :plugin_descriptor_id, :plugin_descriptors, :id, {:name => "metadata_attribute_plugin_descriptor_id_fk"}
  end
end
