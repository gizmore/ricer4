module Ricer4::Extend::ConnectorIs
  def connector_is(allowed_connectors)
    class_eval do |klass|
      
      connectors = klass.define_class_variable(:@plugin_connectors, [])

      Array(allowed_connectors).each do |connector|
        Ricer4::Connector.by_name(connector) or raise Ricer4::ConfigException.new("#{klass.plugin_name} has an invalid connector_is: #{connector}")
        connectors.push(connector.to_sym)
      end
      
      register_exec_function(:execute_connector_is!)
      def execute_connector_is!(line)
        unless get_class_variable(:@plugin_connectors).include?(server.connector.name)
          raise Ricer4::ExecutionException.new("This plugin does not work with #{server.connector.name} connectors.")
        end 
      end
      
    end
  end
end