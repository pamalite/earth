class AddFileMonitorExtensionPointsAndAddMethodColumn < ActiveRecord::Migration
  def self.up
    add_column :plugin_descriptors, :method, :string
    
    Earth::ExtensionPoint.create :name => "add_file", :host_plugin => "FileMonitor", :description => "when a file is added"
    Earth::ExtensionPoint.create :name => "delete_file", :host_plugin => "FileMonitor", :description => "before a file is deleted"
    Earth::ExtensionPoint.create :name => "delete_dir", :host_plugin => "FileMonitor", :description => "before a directory is deleted"
  end

  def self.down
    remove_column :plugin_descriptors, :method
  end
end
