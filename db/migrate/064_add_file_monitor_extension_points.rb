class AddFileMonitorExtensionPoints < ActiveRecord::Migration
  def self.up
    Earth::ExtensionPoint.create :name => "add_file", :host_plugin => "FileMonitor", :description => "bla bla"
    Earth::ExtensionPoint.create :name => "delete_file", :host_plugin => "FileMonitor", :description => "bla bla"
    Earth::ExtensionPoint.create :name => "delete_dir", :host_plugin => "FileMonitor", :description => "bla bla"
  end

  def self.down
  end
end
