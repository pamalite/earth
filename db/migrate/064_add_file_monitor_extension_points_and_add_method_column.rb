class AddFileMonitorExtensionPointsAndAddMethodColumn < ActiveRecord::Migration
  def self.up
    add_column :plugin_descriptors, :method, :string
    
    Earth::ExtensionPoint.create :name => "add_file", :host_plugin => "FileMonitor", :description => "bla bla"
    Earth::ExtensionPoint.create :name => "delete_file", :host_plugin => "FileMonitor", :description => "bla bla"
    Earth::ExtensionPoint.create :name => "delete_dir", :host_plugin => "FileMonitor", :description => "bla bla"
  end

  def self.down
    remove_column :plugin_descriptors, :method, :string
  end
end
