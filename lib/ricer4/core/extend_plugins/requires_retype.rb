module Ricer4::Extend::RequiresRetype
  
  RETYPE_OPTIONS = {
    always: true,
  }
  
  def requires_retype(options={})
    class_eval do |klass|
      
      ActiveRecord::Magic::Options.merge(options, RETYPE_OPTIONS)
      
      # Add new handler to plugin execution chain
      klass.register_exec_function(:execute_retype!) if !!options[:always]
      
      def retyped?
        @@RETYPE.delete(user) == line
      end
      
      def execute_retype!(line)
        execute_retype
      end

      def execute_retype(message="")
        return unless has_scope_and_permission?
        return if retyped?
        @@RETYPE[user] = line
        message += " " unless message.empty?
        raise Ricer4::ExecutionException.new(message+tt('ricer4.extend.requires_retype.msg_retype'))
      end
      
      private

      @@RETYPE = {}

    end
  end
end
