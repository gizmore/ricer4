module Ricer4::Plugins::Fun
  class Decide < Ricer4::Plugin
    
    trigger_is :decide
    
    def plugin_init
      @outcomes = [] # Static var that is reset on reload
    end
    
    def old_outcome(key)
      @outcomes.each do |outcome|
        return outcome[:outcome] if outcome[:key] == key
      end
      nil
    end
    
    def outcome_key(sorted_choices)
      sorted_choices.join("")
    end
    
    has_usage 
    def execute
      rply yes_or_no
    end
    
    def yes_or_no
      bot.rand.rand(0..1) == 1 ? :yes : :no      
    end
    
    has_usage  '<message|named:"decisions">', function: :execute_with_decisions
    def execute_with_decisions(text)
      split_pattern = Regexp.new("\\s+#{t(:or)}\\s+")
      choices = text.rtrim('?').split(split_pattern)
      choices.sort!
      key = outcome_key(choices)
      answer = old_outcome(key)
      return reply answer unless answer.nil?
      if choices.length == 1
        outcome = yes_or_no
      else
        outcome = bot.rand.rand(0..(choices.length-1))
        outcome = choices[outcome]
      end
      @outcomes.unshift({key:key, outcome:outcome})
      @outcomes.slice!(0, 10) if @outcomes.length > 10
      reply outcome
    end
    
  end
end
