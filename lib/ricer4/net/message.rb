module Ricer4
  class Message
    
    def self.current; Thread.current[:ricer_message]; end

    SCOPES_PRIVATE ||= [:bot, :server, :user]
    SCOPES_CHANNEL ||= [:bot, :server, :channel, :user]
    
    attr_reader   :received_at
    attr_accessor :raw, :prefix, :type, :args,
                  :server, :sender, :target,
                  :processed
    
    def line; args[1]; end
    def channel; target if to_channel?; end
    def reply_target; channel || sender; end
    
    def to_query?; target.is_a?(Ricer4::Bot); end
    def from_user?; sender.is_a?(Ricer4::User); end
    def to_channel?; target.is_a?(Ricer4::Channel); end
    def from_server?; sender.nil? || sender == server; end
    def is_privmsg?; type == 'PRIVMSG'; end
    
    def initialize
      @target = bot
      @received_at = DateTime.now
      copy_message_to_thread
    end
    
    def copy_message_to_thread
      Thread.current[:ricer_message] = self
    end

    def add_reply_with(text, plugin=nil, type=Ricer4::Reply::SUCCESS, target=nil)
      add_reply(Ricer4::Reply.new(text, plugin, type, target))
    end
    
    def add_reply(reply)
      if current_command
        current_command.add_reply(reply)
      else
        send_reply(reply)
      end
    end
    
    def send_reply(reply)
      @server.send_reply(reply)
    end
    
    def scope
      to_channel? ? Ricer4::Scope::CHANNEL : Ricer4::Scope::USER
    end
    
    def scopes
      to_channel? ? SCOPES_CHANNEL : SCOPES_PRIVATE
    end
    
    def clone_privmsg(new_line=nil)
      message = self.class.new
      line = new_line || self.line 
      message.raw = "PRIVMSG #{self.sender.hostmask} #{self.server.next_nickname} :#{line}"
      message.prefix = self.prefix
      message.type = 'PRIVMSG'
      message.args = [self.server.next_nickname, line]
      message.server = self.server
      message.sender = self.sender
      message.target = self.target
      message
    end
    
  end
end
