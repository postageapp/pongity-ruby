require 'json'
require 'socket'
require 'net/http'

module Pingity
  # == Submodules ===========================================================
  
  autoload(:ApiMethods, 'pingity/api_methods')
  autoload(:Config, 'pingity/config')
  autoload(:Exceptions, 'pingity/exceptions')
  
  # == Constants ============================================================
  
  VERSION = File.read(File.expand_path(File.join('..', 'VERSION'), File.dirname(__FILE__))).chomp
  API_VERSION = '1.0'.freeze
  API_VERSION_FOR_URI = "v-#{API_VERSION.sub('.', '-')}".freeze

  # == Module Methods =======================================================
  
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
  
  def self.api_method?(method)
    ApiMethods.instance_methods.include?(method)
  end

  extend Pingity::ApiMethods

protected
  def self.api_call(method, options)
    payload = JSON.dump(options.merge(:api_key => Pingity.config.api_key))
    uri = URI("http://#{Pingity.config.api}/api/#{API_VERSION_FOR_URI}/#{method}.json")
    
    response = nil

    if (Pingity.config.verbose)
      puts "Request:\n\t#{payload}"
    end
    
    case (Pingity.config.transport)
    when :curb
    else
      Net::HTTP.start(uri.host, uri.port) do |http|
        http_response = http.post(
          uri.path,
          payload,
          'Content-Type' => 'application/json'
        )

        begin
          response = JSON.load(http_response.body)
        end
      end
    end
    
    puts response.inspect if (Pingity.config.verbose)

    response
    
  rescue SocketError => e
    case (e.to_s)
    when /nodename nor servname provided/
      raise Pingity::Exceptions::NetworkError, "Hostname #{Pingity.config.api.inspect} could not be resolved, adjust 'api' configuration parameter or check DNS."
    else
      raise Pingity::Exceptions::NetworkError, "#{e}"
    end
  end
end
