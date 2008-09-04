#TODO module comments
module Extensions
  
  # The +extension_point+ method is used to create an extension point inside a plugin file
  # It instantiates all plugins which are linked to a specific extension point
  # The extension point (in the extension_points table) should be created while installing the plugin using the +add_extension_point+ method
  # Note: except the extension point at the Earthd which is created when we create the extension_points table
  def extension_point(extension_point_name,host_plugin, *args)
    plugins = []
    #args are the paremetrs should be passed to the plug-in
    #so, put them in the plug-in session
    args.each do |arg|
      $plugin_session = arg
    end

    plugin_manager = PluginManager.new
    #debugger

    #bring all the plug_ins for this extension point using: host_plugin name and the extension_point name
    extension_point = Earth::ExtensionPoint.find(:first, :conditions => {:host_plugin => host_plugin, :name => extension_point_name})
    plugins = extension_point.plugin_descriptors unless extension_point.nil?
    for p in plugins do
      # instantiate the plugin class
      #TODO DELETE ME
      #plugin = get_class_from_name(p.name)

      plugin = plugin_manager.load_plugin(p.name, p.version)



      #we could run a specific plugin method to do some functionality
      #eval 'plugin' + '.' + p.method unless p.method.nil?
    end
    
    #clear the plugin_session
    $plugin_session = {}
  end
  
  # the +add_extension_point+ method creates a new extension point in the extension_points table
  # this method should be used while installing new plugin
  def add_extension_point(name, host_plugin, description)
    Earth::ExtensionPoint.create :name => name, :host_plugin => host_plugin, :description => description
  end
  
  #TODO method comments
  def get_class_from_name(name)
    eval name + '.new'
  end
  
end
