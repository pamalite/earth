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
    
    #add the first extension point which is located at Earthd
    ext = Earth::ExtensionPoint.create :name => "main_loop", :host_plugin => "Earthd", :description => "extension point at the main loop in the earthd script"
    #add file_monitor as a plugin for Earthd
    ext.reload
    
  end

  def self.down
    drop_table :extension_points
    
    #remove the foreign key from the plug-in descriptor table
    remove_column :plugin_descriptors, :extension_point_id

    
  end
end
