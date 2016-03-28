class ActiveRecord::Magic::Param::Url < ActiveRecord::Magic::Param::String
  
   def known_shemes; self.class.default_ports; end
   def self.default_ports
     {
       ssh: 25,
       odbc: 3001,
       http: 80,   https: 443,
       tcp: 23,    ssl: 443,
       ws: 80,     wss: 443,
       ftp: 21,    ftps: 21,
       irc: 6667,  ircs: 6697,
     }
   end
   
   def default_options; super.merge({ schemes: [:http, :https], ping: false, connect: false, ssl_verify: false, max: 4096, min: 12, default: nil }); end
   
   def option_schemes
     option(:schemes)
   end
   
   def input_to_value(input)
     URI.parse(input) rescue nil
   end
   
   def value_to_input(uri)
     uri.to_s
   end
   
   def validate!(uri)
     invalid!(:err_bad_url) if uri.nil?
     validate_scheme!(uri) unless option_schemes.nil?
     validate_ping!(uri) if option(:ping)
     validate_connect!(uri) if option(:connect) && option_schemes
     super(uri.to_s)
     uri.port ||= self.class.default_ports[uri.scheme.to_sym]
   end
   
   def validate_scheme!(uri)
     invalid_scheme!(uri) unless option_schemes.include?(uri.scheme.to_sym)
   end
   def invalid_scheme!(uri)
     invalid!(:err_invalid_scheme, allowed: human_join(option_schemes))
   end
   
   def validate_ping!(uri)
     invalid!(:err_ping_failed, host: uri.host) unless pings?(uri)
   end
   def pings?(uri)
     output = `ping -W 1.0 -c 1 #{Shellwords.escape(uri.host)}`
     output.index("1 received") >= 0 rescue false
   end

   def validate_connect!(uri)
   end

end
