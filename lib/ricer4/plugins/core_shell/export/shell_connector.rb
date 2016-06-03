module Ricer4::Connectors
  class Shell < Ricer4::Connector
    
    include Ricer4::Include::UserConnector

    def connect!
      bot.log.debug("Connectors::Shell.connect!")
      @connected = true
      @server.set_online(true)
      while bot.running && @connected
        sleep 15
      end
    end

    def disconnect!
      bot.log.debug("Connectors::Shell.disconnect!")
      @connected = false
      @server.set_online(false)
    end
    
    def protocol
      'tty'
    end
    
    def send_from_tty(line)
      message = Ricer4::Message.new
      message.server = self.server
      message.sender = self.get_tty_sender
      bot.parser.process_line(line)
    end
    
    def get_tty_sender
      user = load_or_create_user(server, get_tty_sender_name)
      unless user.registered?
        user.permissions = Ricer4::Permission::AUTHENTICATED.bit
        user.password = "1111"
      end
      user.login!
      user.localize!
    end

    def get_tty_sender_name
      "gizmore"
    end
    
    def send_reply(reply)
      puts reply.text
    end
    
    def send_quit(text)
      puts text
      disconnect!
    end
    
  end
end
