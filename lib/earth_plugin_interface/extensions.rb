#TODO module comments
module Extensions
  
  #TODO method comments
  def extension_point(extinsion_point_name,host_plugin, *args)
    #args are the paremetrs should be passed to the plug-in
    #so, put them in the plug-in session
    args.each do |arg|
      $plugin_session = arg
    end


    #bring all the plug_ins for this extension point
    #debugger
    extension_point = Earth::ExtensionPoint.find(:first, :conditions => {:host_plugin => host_plugin, :name => extinsion_point_name})
    plugins = extension_point.plugin_descriptors
    for p in plugins do
      #instantiate the plugin class
      plugin = PluginManager.get_plugin_class_from_name(p.name)
      #run a specific plugin method to do some functionality
      #PluginManager.plugin_method(plugin.method) unless p.method.nil?
    end
    
    #clear the plugin_session
    $plugin_session = {}
  end
  
end
