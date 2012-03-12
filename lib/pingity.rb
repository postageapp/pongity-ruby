require 'json'

module Pingity
  autoload(:Config, 'pingity/config')
  
  VERSION = File.read(File.expand_path(File.join('..', 'VERSION'), File.dirname(__FILE__))).chomp
  API_VERSION = '1.0'
  
  def self.config(options = nil)
    @config = nil if (options)
    
    @config ||= Pingity::Config.new(options)
  end
  
  def self.configured?
    self.config.valid?
  end
  
  def self.version
    VERSION
  end

  def self.api_version
    API_VERSION
  end
  
  def self.push(path, value)
    
  end
end
