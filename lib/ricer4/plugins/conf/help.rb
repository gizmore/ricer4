module Ricer4::Plugins::Conf
  class Help < Ricer4::Plugin
    
    trigger_is :help
    
    bruteforce_protected :always => false
    
    has_usage  '<plugin>', function: :execute_help
    def execute_help(plugin)
      reply plugin.plugin_help rescue rply :err_no_help
    end
        
    has_usage '', function: :execute_list
    has_usage '<boolean>', function: :execute_list
    def execute_list(all=false)
      return if bruteforcing? # Manual bruteforce protection
      grouped = collect_groups(all)
      grouped = Hash[grouped.sort]
      grouped.each do |k,v|; grouped[k] = v.sort; end
      nreply_to(sender, t(:msg_triggers, :triggers => grouped_output(grouped)))
    end
    
    protected
    
    def help_plugins(all=false)
      bot.loader.plugins.select{|plugin| all || plugin.respond_to?(:usages) }
    end
    
    private
    
    def collect_groups(all=false)
      grouped = {}
      help_plugins(all).each do |plugin|
        if all || plugin.has_scope_and_permission?
          m = plugin.plugin_module
          grouped[m] ||= []
          grouped[m].push(plugin.plugin_trigger||plugin.plugin_name)
        end
      end
      grouped
    end
    
    def grouped_output(grouped)
      out = []
      grouped.each do |k,v|
        group = bold_text(k) + ': ' # Module:
        group += join(v) # trigger, trigger
        out.push(group)
      end
      out.join('. ')
    end
    
  end
end
