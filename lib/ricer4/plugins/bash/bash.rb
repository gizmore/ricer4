module Ricer4::Plugins::Bash
  class Bash < Ricer4::Plugin
    
    trigger_is "bash"
    
    has_subcommands
    
    has_usage
    has_usage '<bash_provider>'
    def execute(provider=nil)
      provider ||= get_plugin('Bash/SetProvider').default_provider
      threaded do
        quote = provider.random
        get_plugin('Bash/Show').execute_show([quote])
      end
    end
    
  end
end