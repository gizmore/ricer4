module Ricer4::Plugins::Bash
  class Get < Ricer4::Plugin
    
    trigger_is "bash.get"
    
    has_usage '<id>'
    def execute(id)
      provider = get_plugin('Bash/SetProvider').default_provider
      quote = provider.get(id)
      get_plugin('Bash/Show').execute_show([quote])
    end

  end
end