class CreateExtensionPoints < ActiveRecord::Migration
  def self.up
    create_table :extension_points do |t|
      t.column :name, :string
      t.column :description, :string
      t.column :plugin_descriptor_id, :integer
    end
    
    #TODO this is temporarily until we read the code from the database
    change_column :plugin_descriptors, :code, :binary, :null => true
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => true
  end

  def self.down
    drop_table :extension_points
    #TODO this is temporarily until we read the code from the database
    change_column :plugin_descriptors, :code, :binary, :null => false
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => false    
  end
end
