module Ricer4
  class Connector
    
    arm_events

    attr_reader :server
    
    def self.by_name(connector)
      begin
        Ricer4::Connectors.const_get(connector.to_s.camelcase)
      rescue
        raise Ricer4::UnknownConnectorException.new(connector)
      end
    end
    
    def name
      self.class.name.rsubstr_from('::').underscore.to_sym
    end
    
    def initialize(server)
      @server = server
      @stub = Ricer4::Message.new
      @stub.raw = ""; @stub.prefix = "";
      @stub.type = "000"; @stub.args = []
      @stub.server = @stub.sender = server
      @stub.target = bot
      after_initialize
    end
    
    def after_initialize
    end
    
    def connected?
      @connected
    end

    def stub_message
      @stub
    end
    
  end
end

module Ricer4::Connectors
end
