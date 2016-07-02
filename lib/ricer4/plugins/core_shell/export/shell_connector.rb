module Ricer4::Connectors
  class Shell < Ricer4::Connector
    
    include Ricer4::Include::UserConnector
    
    attr_accessor :tty_user_name

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
    
    def send_from_tty(msg)
      message = tty_message
      user = message.sender
      user.hostmask = 'localhost'
      message.raw = msg
      message.prefix = user.hostmask
      message.type = "PRIVMSG"
      message.args = [user.name, msg]
      arm_publish("ricer/incoming", message.raw)
      arm_publish("ricer/receive", message)
      arm_publish("ricer/received", message)
      arm_publish("ricer/messaged", message)
    end
    
    def tty_message
      message = Ricer4::Message.new
      message.server = self.server
      message.sender = self.get_tty_sender
      message
    end

    def get_tty_sender
      user = load_or_create_user(server, get_tty_sender_name)
      unless user.registered?
        user.locale = ActiveRecord::Magic::Locale.by_iso('bot')
        user.register(Ricer4::Permission.all_granted.bits)
        user.password = "1111"
        user.grant(Ricer4::Permission.all_granted.bits)
      end
      if !user.authenticated?
        user.login!
      end
      user.set_online(true)
      user.save!
      user.localize!
    end

    def get_tty_sender_name
      @tty_user_name || "gizmore"
    end
    
    def send_reply(reply)
      @tty_output.push(reply.text)
      puts reply.text
    end
    
    def send_quit(text)
      send_reply(text)
      disconnect!
    end
    
    def clear_tty_output
      @tty_output = []
    end
    
    def tty_output
      result = @tty_output
      @tty_output = []
      result
    end
    
  end
end
