module Ricer4::Plugins::Ai
  class Notice < Ricer4::Plugin
    
    trigger_is :notice
    
    has_usage  '<user|online:true> <message>', permission: :owner, scope: :user
    has_usage  '<user|online:true> <message>', permission: :halfop, scope: :channel
    has_usage  '<channel|online:true> <message>', permission: :halfop, scope: :user
    has_usage  '<channel|online:true> <message>', permission: :voice, scope: :channel
    def execute(target, message)
      target.send_notice(message)
    end
    
  end
end
