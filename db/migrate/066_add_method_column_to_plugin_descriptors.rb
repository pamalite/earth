class AddMethodColumnToPluginDescriptors < ActiveRecord::Migration
  def self.up
    add_column :plugin_descriptors, :method, :string
  end

  def self.down
    remove_column :plugin_descriptors, :method
  end
end
