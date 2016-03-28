module Ricer4::Plugins::Internet
  class Hping < Ricer4::Plugin
    
    trigger_is "net.ping"
    permission_is :operator
    
    has_usage('<string|named:"domain">')
    has_usage('<string|named:"domain"> <integer|named:"count",min:1,max:10,default:3>')
    def execute(domain, count=3)
      threaded do
        reply(`ping -c #{count} #{Shellwords.escape(domain)}`)
      end
    end
    
  end
end