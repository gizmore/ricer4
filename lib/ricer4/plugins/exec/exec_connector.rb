###
### The exec connector is invoked via exec rice
###
module Ricer4::Connectors
  class Exec < Ricer4::Connector

    def connect!
      server.set_online(true)
    end
    
    def disconnect!
      @connected = false
    end
    
    ################
    ### Messages ###
    #################
    def send_reply(reply)
      send_to(reply.target, reply.text)
    end

    def send_to_all(line)
      server.users.online.each { |user| send_to(user, line) }
    end

    def send_to(user, text)
      begin
        puts "#{user.display_name} >> #{text}"
      rescue StandardError => e
        bot.log.exception(e)
      end
    end
    
    def send_quit(line)
      disconnect!
    end

  end
end
