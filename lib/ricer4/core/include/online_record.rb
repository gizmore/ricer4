#
# Generic online based caching extender.
# Usually only users, channels, perms, etc. that are online should be in the ricer cache.
#
module Ricer4::Include::OnlineRecord
  
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
    def online
      self.where(online: true)
    end
    def offline
      self.where(online: false)
    end
  end
  
  ################
  ### Instance ###
  ################

  # set_online saves the class instantly and updates the cache implicitly.
  module InstanceMethods
    def online?; self.online; end
    def offline?; !self.online; end
    def set_offline; set_online(false); end
    def set_online(online=true); self.update_attribute(:online, online); end
  end

end
