require 'yaml'

class Pingity::Config
  DEFAULT_OPTIONS = {
    :config_path => "~/.pingityrc",
    :api => 'api.pingity.com',
    :api_key => nil,
    :verbose => false
  }.freeze
  
  ENV_VARIABLE_PREFIX = /^PINGITY_/.freeze

  def initialize(options = nil)
    @options = DEFAULT_OPTIONS.dup
    
    if (options)
      @options.merge!(options)
    end
    
    ENV.each do |variable, value|
      next unless (variable.match(ENV_VARIABLE_PREFIX))
      
      key_name = variable.sub(ENV_VARIABLE_PREFIX, '').downcase
      
      next if (key_name.empty?)
      
      @options[key_name.to_sym] = value
    end
    
    config_path = File.expand_path(@options[:config_path])
    
    if (config_path and !config_path.empty? and File.exist?(config_path))
      config = YAML.load(File.read(config_path))
      
      @options.merge!(Hash[
        config.collect do |k, v|
          [ k.to_sym, v ]
        end
      ])
    end
  end
  
  def valid?
    !!(@api_key and !@api_key.empty?)
  end
  
  def transport
    :net_http
  end
  
  DEFAULT_OPTIONS.keys.each do |name|
    define_method(name) do
      @options[name]
    end

    define_method(:"#{name}=") do |value|
      @options[name] = value
    end
  end
end
