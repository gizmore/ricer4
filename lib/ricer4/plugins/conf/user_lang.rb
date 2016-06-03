module Ricer4::Plugins::Conf
  class UserLang < Ricer4::Plugin
    
    trigger_is :lang
    
    def self.available
      ActiveRecord::Magic::Locale.all.collect{|l|l.iso}.join(', ')
    end
    
    has_usage '<locale>' , function: :execute_set_user_language
    has_usage '', function: :execute_show_user_language
    
    def execute_show_user_language
      rply :msg_show, :iso => user.locale.to_label, :available => self.class.available
    end
    
    def execute_set_user_language(language)
      old_language = user.locale
      user.locale = language
      user.save!
      rply :msg_set, :old => old_language.to_label, :new => language.to_label
    end

  end
end
