###
### Removes enable/disable functionality
###
module Ricer4::Extend::AlwaysEnabled
  def always_enabled(bool=true)
    class_eval do |klass|
      if bool
        # Remove setting from the plugin to mimic it is not there
        if settings = get_class_variable(:@mem_settings)
          settings.delete_if { |setting| setting[:name] == :plugin_enabled }
        end
        # Always on!
        def plugin_enabled?
          true
        end
      end
    end
  end
end
