#
#
# math 4 && math 6 => 4 6
#
# math 4 + $(strlen abc)
#  
# flatten $(ping $(math 1+2 && math 3+4) && ping) | mailto peter@lustig.de
# flatten $(ping $(3 && math 3+4) && ping) | mailto peter@lustig.de
# flatten $(ping 3 $(math 3+4) && ping) | mailto peter@lustig.de
#
class Ricer4::Command
  
  include Ricer4::Include::Base

  arm_events
  
  attr_reader   :plugin, :failed, :counter
  attr_accessor :parent, :next, :prev, :text
  attr_accessor :processed, :processing, :threading
  attr_reader   :sent_replies
  
  def self.current; Thread.current[:ricer_command]; end
  def self.current=(command); Thread.current[:ricer_command] = command; end
  
  @@counter = 0 # DBG

  def initialize(plugin=nil)
    @@counter += 1; @counter = @@counter # DBG
    @plugin = plugin
    @tokens, @replies, @parent, @text, @next = nil
    @processed, @processing, @threading, @failed = false
    @sent_replies = []
  end
  
  def has_tokens?; @tokens != nil; end
  def tokens; @tokens ||= []; end
  def has_replies?; @replies != nil; end
  def replies; @replies ||= []; end
  # def last_replies; @last_replies ||= []; end

  # DBG
  def to_string
    back = "["
    back += "#{@counter}#{@parent?'p':''}:"
    back += "#{@plugin.plugin_name}" if @plugin
    back += ";" + @text if @text
    if @tokens
      @tokens.each do |token|
        back += token.to_string
      end
    end
    back += "<P>]" if @plugin && @processed
    back += "<I>]" if @plugin && @processing
    back += "]"# if @plugin
    back += " && #{@next.to_string}" if @next
    back
  end
  
  
  def add_reply(reply)
    bot.log.debug("Ricer4::Command.add_reply(#{reply.text}) CMD: #{to_string}")
    replies.push(reply)
    @failed = reply.is_failure?
  end
  
  def push_quote_text(text)
    push_text("\x19#{text}\x19")
  end

  def push_text(text)
    unless text.trim.empty?
      command = self.class.new()
      command.text = text.trim
      command.parent = self
      command.processed = true
      tokens.push(command)
    end
    self
  end
  
  def process
    bot.log.debug("Command.process "+self.to_string)
    if !@processing
      if @plugin && tokens_complete?
        begin
          @processing = true
          bot.log.debug("Command.process #{self.to_string} PROCESSING WITH: '#{self.line}'")
          self.class.current = self
          @plugin.call_exec_functions(self.line)
          self.class.current = self.parent
        rescue StandardError => e
          @plugin.reply_exception(e)
        ensure
          late_processed unless @threading
        end
      end
      process_tokens if @tokens
    end
  end
  
  def process_tokens
    @tokens.each do |token|
      token.process unless token.processed
    end
  end
  
  def late_processed
    bot.log.debug("Command.late_processed #{to_string}")
    gather_results
    unless @failed
      if @next
        consume_next_command
      end
      if @parent
        @parent.process
      elsif @processed
        command_finished
      elsif !@processing
        process
      end
    else
      command_finished
    end
  end
  
  def tokens_complete?
    @tokens.each{|token| return false unless token.tokens_complete? && token.processed } if @tokens
    true
  end
  
  def consume_next_command
    n = @next
    @next = n.next
    @plugin = n.plugin
    @counter = n.counter
    @tokens = n.has_tokens? ? n.tokens : nil
    @processed, @processing, @threading = false
  end

  def command_finished
    byebug
    arm_publish("ricer/command/finished", self)
  end
  
  def send_replies
    replies.each do |reply|
      @sent_replies.push(reply)
      current_message.send_reply(reply)
    end
  end

  def gather_results
    bot.log.debug("Command.gather_results #{self.to_string}")
    @processed = true
    @text ||= ""
    if @replies
      if @parent && (!@failed)
        @text += " "
        @text += @replies.collect{|reply| reply.text }.join(" ")
        @text.ltrim!
        bot.log.debug("Command.gather_results: '#{@text}'")
      else
        send_replies
      end
      @replies = nil
    end
  end
  
  def line
    back = ""
    back += @tokens.collect{|token|token.text}.join(" ") if @tokens
    back
  end
  
end
