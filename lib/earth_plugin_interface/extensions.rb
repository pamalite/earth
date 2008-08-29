module Extensions
  
  #TODO method comments
  def extension_point(id, *args)
    #args are the paremetrs should be passed to the plug-in
    #so, put them in the plug-in session
    args.each do |arg|
      $plugin_session = arg
    end


    #bring all the plug_ins for this extension point
    ext_id = id
    #debugger
    plugins = Earth::PluginDescriptor.find(:all, :conditions => {:extension_point_id => ext_id})
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
