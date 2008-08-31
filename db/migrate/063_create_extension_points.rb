class CreateExtensionPoints < ActiveRecord::Migration
  def self.up
    create_table :extension_points do |t|
      t.column :name, :string, :null => false
      #TODO this could be changed to be a foriegn key to the plug-in descriptors
      #currently, just leave it as a class name (Sting)
      t.column :host_plugin, :string, :null => false
      t.column :description, :text, :null => false
    end
    
    #add a foreign key to the plug-in descriptor table
    add_column :plugin_descriptors, :extension_point_id, :integer
    
    
    #TODO this is temporarily until we read the code from the database
    change_column :plugin_descriptors, :code, :binary, :null => true
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => true
    
    
    #add the first extension point which is located at Earthd
    ext = Earth::ExtensionPoint.create :name => "main_loop", :host_plugin => "Earthd", :description => "extension point at the main loop in the earthd script"
    #add file_monitor as a plugin for Earthd
    ext.reload
    #TODO here we should upload the code to the database
    ext.plugin_descriptors.create :name => "FileMonitor", :version => 1

    
  end

  def self.down
    drop_table :extension_points
    
    #remove the foreign key from the plug-in descriptor table
    remove_column :plugin_descriptors, :extension_point_id
    
    
    #TODO this is temporarily until we read the code from the database
    #remove all columns with null values in the code or sha1_signature
    #I do not know why this does not work!!! so, I just delete all the plugins
    #all_null_plugins = Earth::PluginDescriptor.find(:all,:conditions => ["code = ? OR sha1_signature = ?",nil,nil])
    all_null_plugins = Earth::PluginDescriptor.find(:all)
    for p in all_null_plugins do
      p.destroy
    end
    
    change_column :plugin_descriptors, :code, :binary, :null => false
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => false    
  end
end
