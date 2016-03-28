module Ricer4::Extend::FloodingProtected
  def flooding_protected(boolean=true)
    class_eval do |klass|
      
      if boolean
      
        def flooding?
          last = sender.instance_variable_defined?(:@last_msg_time) ? sender.instance_variable_get(:@last_msg_time) : 0.0
          now = Time.now.to_f
          elapsed = now - last
          if elapsed <= server.cooldown
            bot.log.info "#{user.name} is FLOODING!"
            return true
          else
            sender.instance_variable_set(:@last_msg_time, now)
            return false
          end
        end
      
      else
        
        def flooding?
          false
        end

      end
      
    end
  end
end
