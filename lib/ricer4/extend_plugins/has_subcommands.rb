module Ricer4::Extend::HasSubcommands
  def has_subcommands
    class_eval do |klass|

      def plugin_description(long)
        long ? "#{super}#{plugin_subcommand_description}" : "#{super}"
      end
      
      protected
      
      def plugin_subcommand_description
        tt!('ricer3.subcommands', triggers: join(plugin_subcommand_trigers))
      end
      
      def plugin_subcommand_trigers
        plugin_subcommands.collect { |plugin| plugin.plugin_trigger }.sort
      end

      def plugin_subcommands
        plugins = []
        plugin_module = plugin_module_object.name.demodulize#.camelcase
        plugin_module_object.constants(true).each do |constant|
          if plugin = get_plugin("#{plugin_module}/#{constant}")
            if plugin.plugin_trigger
              plugins.push(plugin) if plugin != self
            end
          end
        end
        plugins
      end
      
    end
  end    
end