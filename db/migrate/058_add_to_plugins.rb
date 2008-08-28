class AddToPlugins < ActiveRecord::Migration
  def self.up
    add_column :plugin_descriptors,:extension_point_id, :integer
    change_column :plugin_descriptors, :code, :binary, :null => true
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => true
  end

  def self.down
    remove_column :plugin_descriptors,:extension_point_id
    change_column :plugin_descriptors, :code, :binary, :null => false
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => false
  end
end
