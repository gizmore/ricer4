module Ricer4::Plugins::Debug
  class Dbtrace < Ricer4::Plugin
    
    trigger_is "db.trace"
    permission_is :responsible

    has_usage "" and has_usage "<boolean>" 
    def execute(boolean=nil)
      @tracing ||= false; @tracing = boolean.nil? ? !@tracing : boolean
      ActiveRecord::Base.logger = @tracing ? Logger.new(STDOUT) : nil
      ActiveRecord::Base.logger.level = 0 if @tracing 
      rply @tracing ? :msg_enabled : :msg_disabled
    end
    
  end
end