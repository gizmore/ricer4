##
## Enriches plugins with some default settings and core extenders.
## Adds reply functions and exception beautifier
##
## @example trigger_is :ping
##
module Ricer4::Extend::TriggerIs
  TRIGGER_IS_OPTIONS ||= {
    default_enabled: true,
    always_enabled: false,
    disable_perm_server: :ircop,
    disable_perm_channel: :operator,
    disable_perm_bot: :responsible,
  }
  def trigger_is(trigger, options={})
    class_eval do |klass|
      
      ActiveRecord::Magic::Options.merge(options, TRIGGER_IS_OPTIONS)
      
      define_class_variable(:@trigger_cache, {})
      define_class_variable(:@default_trigger, trigger.to_s.downcase)
      
      if options[:always_enabled]
        always_enabled(true)
      else
        default_enabled(options[:default_enabled], options.except(:default_enabled, :always_enabled))
      end

      def plugin_trigger
        get_class_variable(:@trigger_cache)[I18n.locale] ||= begin
          I18n.t!(tkey(:trigger)) rescue get_class_variable(:@default_trigger)
        end
      end

    end
  end
end

