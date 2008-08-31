#TODO module comments
module Extensions
  
  # The +extension_point+ method is used to create an extension point inside a plugin file
  # It instantiates all plugins which are linked to a specific extension point
  # The extension point (in the extension_points table) should be created while installing the plugin using the +add_extension_point+ method
  # Note: except the extension point at the Earthd which is created when we create the extension_points table
  def extension_point(extinsion_point_name,host_plugin, *args)
    #args are the paremetrs should be passed to the plug-in
    #so, put them in the plug-in session
    args.each do |arg|
      $plugin_session = arg
    end


    #bring all the plug_ins for this extension point using: host_plugin name and the extension_point name
    #debugger
    extension_point = Earth::ExtensionPoint.find(:first, :conditions => {:host_plugin => host_plugin, :name => extinsion_point_name})
    plugins = extension_point.plugin_descriptors
    for p in plugins do
      # instantiate the plugin class
      plugin = PluginManager.get_plugin_class_from_name(p.name)
      #TODO we could run a specific plugin method to do some functionality
      # Currently not used. The plugin should do its job when instantiated
      # PluginManager.plugin_method(plugin.method) unless p.method.nil?
    end
    
    #clear the plugin_session
    $plugin_session = {}
  end
  
  # the +add_extension_point+ method creates a new extension point in the extension_points table
  # this method should be used while installing new plugin
  def add_extension_point(name, host_plugin, description)
    Earth::ExtensionPoint.create :name => name, :host_plugin => host_plugin, :description => description
  end
  
end
