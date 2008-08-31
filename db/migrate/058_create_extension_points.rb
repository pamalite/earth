class CreateExtensionPoints < ActiveRecord::Migration
  def self.up
    create_table :extension_points do |t|
      t.column :name, :string, :null => false
      #TODO this could be changed to be a foriegn key to the plug-in descriptors
      #currently, just leave it as a class name (Sting)
      t.column :host_plugin, :string, :null => false
      t.column :description, :text, :null => false
    end
    
    #add the first extension point which is located at Earthd
    Earth::ExtensionPoint.create :name => "main_loop", :host_plugin => "Earthd", :description => "extension point at the main loop in the earthd script"
    
    #TODO this is temporarily until we read the code from the database
    #add a foreign key to the plug-in descriptor table
    add_column :plugin_descriptors, :extension_point_id, :integer
    change_column :plugin_descriptors, :code, :binary, :null => true
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => true
    
  end

  def self.down
    drop_table :extension_points
    #TODO this is temporarily until we read the code from the database
    #remove the foreign key from the plug-in descriptor table
    remove_column :plugin_descriptors, :extension_point_id
    #remove all columns with null values in the code or sha1_signature
    Earth::PluginDescriptor.delete_all("code = NULL OR sha1_signature = NULL")
    change_column :plugin_descriptors, :code, :binary, :null => false
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => false    
  end
end
