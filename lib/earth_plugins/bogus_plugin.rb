class BogusPlugin < EarthPlugin
  def self.plugin_name
    "EarthBogusPlugin"
  end

  def self.plugin_version
    1
  end
  
  
  def initialize
    #bring the parameters from the plug-in session
    @logger = get_param(:logger)
    @logger.debug("Mr Bogus... he is the hero!!");
  end
end
