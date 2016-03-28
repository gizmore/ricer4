module Ricer4::Plugins::Chat
  class Action < Ricer4::Plugin
    
    trigger_is :action
    
    has_usage  '<user|online:true> <message>', permission: :owner, scope: :user
    has_usage  '<user|online:true> <message>', permission: :halfop, scope: :channel
    has_usage  '<channel|online:true> <message>', permission: :halfop, scope: :user
    has_usage  '<channel|online:true> <message>', permission: :voice, scope: :channel
    def execute(target, message)
      target.send_action(message)
    end
    
  end
end
