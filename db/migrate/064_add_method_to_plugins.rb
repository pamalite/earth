class AddMethodToPlugins < ActiveRecord::Migration
  def self.up
    add_column :plugin_descriptors,:method, :string
    #remove unique name constraint from plugin_descriptors
    execute "ALTER TABLE plugin_descriptors DROP CONSTRAINT plugin_descriptors_unique_name"
    #TODO create constraint that name + method should be unique in plugin_descriptors
  end

  def self.down
    remove_column :plugin_descriptors, :method
    
    #TODO remove constraint that name + method should be unique in plugin_descriptors
    
    #add unique name constraint from plugin_descriptors
    execute "ALTER TABLE plugin_descriptors ADD CONSTRAINT plugin_descriptors_unique_name UNIQUE (name)"
  end
end
