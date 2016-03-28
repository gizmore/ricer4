module Ricer4::Plugins::Art
  class Cowsay < Ricer4::Plugin
    
    trigger_is :cowsay
    
    permission_is :halfop

    bruteforce_protected timeout: 12.seconds
    
    has_setting name: :image, type: :cowsay_image, scope: :user, permission: :halfop, enums: [:default], default: :default
    
    has_usage '<cowsay_image|cli:1,named:"image",default:nil> <message>'
    has_usage '<message>'
    def execute(enum=nil, message)
      threaded do
        text = Shellwords.escape(message)
        image = enum || get_setting(:image)
        response = `cowsay -f #{image} -- #{text}`
        if response.nil?
          erply :err_no_cowsay
        else
          reply response
        end
      end
    end
    
  end
end
