module Ricer4::Connectors
  class Shell < Ricer4::Connector
    
    include Ricer4::Include::UserConnector

    def connect!
      server.connected = true
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
      load_or_create_user(server, get_tty_sender_name)
    end

    def get_tty_sender_name
      "gizmore"
    end
    
    def send_reply(a)
#      puts a.text
    end
    
  end
end
