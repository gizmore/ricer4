module Ricer4::Plugins::Ai
  class Message < Ricer4::Plugin
    
    trigger_is :message
    permission_is :halfop
    
    has_usage  '<user|online:true> <message>', permission: :owner, scope: :user
    has_usage  '<user|online:true> <message>', permission: :halfop, scope: :channel
    has_usage  '<channel|online:true> <message>', permission: :halfop, scope: :user
    has_usage  '<channel|online:true> <message>', permission: :voice, scope: :channel
    def execute(target, text)
      target.send_message(text)
    end
    
  end
end
