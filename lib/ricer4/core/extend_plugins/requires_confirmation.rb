module Ricer4::Extend::RequiresConfirmation
  
  CONFIRM_OPTIONS ||= {
    always: true,
    random: false,
  }
  
  def requires_confirmation(options={})
    class_eval do |klass|
      
      ActiveRecord::Magic::Options.merge(options, CONFIRM_OPTIONS)
  
      klass.register_exec_function(:execute_confirmation) if !!options[:always]
      
      klass.define_class_variable(:@requires_random_word, !!options[:random])
      
      def execute_confirmation(line)
        return unless has_scope_and_permission?
        privmsg_line = current_message.line
        if @@CONFIRM[user]
          waitingfor = @@CONFIRM[user] + " #{confirmationword}"
          if waitingfor == privmsg_line
            current_message.args[1].substr_to!(" #{confirmationword}")
            @@CONFIRM.delete(user)
            return
          end
        end
        @@CONFIRM[user] = privmsg_line.substr_to(" #{confirmationword}")||privmsg_line
        raise Ricer4::ExecutionException.new(tt('ricer4.extend.requires_confirmation.msg_confirm',
          command: @@CONFIRM[user],
          word: confirmationword,
        ))
      end
      
      @@CONFIRM = {}

      def confirmationword
        get_class_variable(:@requires_random_word) ?
          SecureRandom.base64(3) :
          tt('ricer4.extend.requires_confirmation.word')
      end
      
    end
  end
end
