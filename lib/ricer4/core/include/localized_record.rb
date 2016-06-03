#
# Generic online based caching extender.
# Usually only users, channels, perms, etc. that are online should be in the ricer cache.
#
module Ricer4::Include::LocalizedRecord
  
  # include extend pattern
  def self.included base
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end
  
  #############
  ### Class ###
  #############

  # scope selector helpers
  module ClassMethods
    # def within_timezone(timezone)
    # end
    # def speaking(locale)
    # end
  end
  
  ################
  ### Instance ###
  ################

  module InstanceMethods
    
    def locale; ActiveRecord::Magic::Locale.by_id(self.locale_id); end
    def timezone; ActiveRecord::Magic::Timezone.by_id(self.timezone_id); end
    def encoding; ActiveRecord::Magic::Encoding.by_id(self.encoding_id); end

    def locale=(locale); self.locale_id = locale == nil ? nil : locale.id; end
    def timezone=(timezone); self.timezone_id = timezone == nil ? nil : timezone.id; end
    def encoding=(encoding); self.encoding_id = encoding == nil ? nil : encoding.id; end

    def localized(&block)
      old_locale, old_timezone = I18n.locale, Time.zone
      localize!
      yield
      I18n.locale, Time.zone = old_locale, old_timezone
      nil
    end
    
    def localize!
      I18n.locale = self.locale.iso
      Time.zone = self.timezone.iso
      self
    end

  end

end
