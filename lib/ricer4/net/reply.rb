module Ricer4
  class Reply
    
    SYSTEM = 0 # VARIOUS
    SUCCESS = 1 # PRIVMSG
    FAILURE = 2 # PRIVMSG
    ACTION = 4 # PRIVMSG \x01
    MESSAGE = 5 # NOTICE or PRIVMSG
    PRIVMSG = 6 # PRIVMSG
    NOTICE = 7 # NOTICE
    
    attr_reader :message, :sent_at
    attr_reader :text, :plugin, :type, :target

    def is_system?; @type == SYSTEM; end
    def is_message?; @type == MESSAGE; end
    def is_failure?; @type == FAILURE; end
    def is_action?; @type == ACTION; end

    def initialize(text, plugin=nil, type=SYSTEM, target=nil)
      #puts "Reply.initialize(#{text}, #{type}, #{target.class.name}#{target.object_id})"
      @text, @message, @plugin, @type = text, Ricer4::Message.current, plugin, type
      @target = target || reply_target
      @sent_at = DateTime.now
    end
    
    def reply_target
      @message.to_channel? ? @message.channel : @message.sender
    end

    def split_clone(text)
      self.class.new(text, @plugin, @type)
    end
    
  end
end