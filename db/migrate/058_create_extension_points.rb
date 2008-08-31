class CreateExtensionPoints < ActiveRecord::Migration
  def self.up
    create_table :extension_points do |t|
      t.column :name, :string, :null => false
      #TODO this could be changed to be a foriegn key to the plug-in descriptors
      #currently, just leave it as a class name (Sting)
      t.column :host_plugin, :string, :null => false
      t.column :description, :string, :null => false
    end
    
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
    change_column :plugin_descriptors, :code, :binary, :null => false
    change_column :plugin_descriptors, :sha1_signature, :binary, :null => false    
  end
end
