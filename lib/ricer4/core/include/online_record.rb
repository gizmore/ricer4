module Ricer4::Include::OnlineRecord
  
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
    def set_online(online)
      if self.online != online
        self.online = online; save!
        online ? self.class.arm_cache_add(self) : self.class.arm_cache_remove(self)
      end
      self
    end
  end

  module ClassMethods
    def online
      self.where(online: true)
    end
    def offline
      self.where(online: false)
    end
  end
  
end
