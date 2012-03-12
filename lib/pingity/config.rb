require 'yaml'

class Pingity::Config
  DEFAULT_OPTIONS = {
    :config_path => "~/.pingityrc",
    :api_key => nil
  }.freeze
  
  ENV_VARIABLE_PREFIX = /^PINGITY_/.freeze

  def initialize(options = nil)
    @options = DEFAULT_OPTIONS.dup
    
    if (options)
      @options.merge!(options)
    end
    
    ENV.each do |variable, value|
      if (variable.match(ENV_VARIABLE_PREFIX))
        key_name = variable.sub(ENV_VARIABLE_PREFIX, '').downcase
        
        unless (key_name.empty?)
          @options[key_name.to_sym] = value
        end
      end
    end
    
    config_path = File.expand_path(@options[:config_path])
    
    if (config_path and !config_path.empty? and File.exist?(config_path))
      config = YAML.load(File.read(config_path))
      
      options.merge(config)
    end
  end
  
  def valid?
    !!(@api_key and !@api_key.empty?)
  end
end
