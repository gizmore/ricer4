###
### Protect a plugin against bruteforcing attempts, by using a timeout.
### All bruteforce protected plugins share the same timeout slot, so you cannot bruteforce all protected plugins each N seconds, only one of them.
### The timeout is configureable. the class method just sets a default.
###
### @example bruteforce_protected always: false, timeout: 10.seconds
###
### @option always  - indicates if the check shall be done automatically or you will need to call "#bruteforcing?" yourself.+
### @option timeout - the timeout which will unlock this plugin.
###
module Ricer4::Extend::BruteforceProtected
  DEFAULT_BF_PROTECT_OPTIONS ||= {
    always: true,
    timeout: 7.seconds,
  }
  def bruteforce_protected(options={})
    
    ActiveRecord::Magic::Options.merge(options, DEFAULT_BF_PROTECT_OPTIONS)

    class_eval do |klass|
      
      # Add timeout settings
      klass.has_setting name: :bruteforce_timeout_seconds, scope: :user, permission: :ircop, type: :duration, min: 0, max: 10.years, default: options[:timeout]

      # Register execution function when always option is enabled
      klass.register_exec_function(:not_bruteforcing?) if options[:always]

      protected

      def timeout; get_setting(:bruteforce_timeout_seconds); end
      def not_bruteforcing?(line=nil); !bruteforcing?; end
      def bruteforcing?
        @BF_TRIES ||= {}
        clear_tries
        if @BF_TRIES[sender].nil?
          register_attempt and return false
        else
          error_bruteforce
        end
      end
      
      private

      def display_timeout
        human_duration(timeout_seconds)
      end
      
      def timeout_seconds
        @BF_TRIES[sender] - Time.now.to_f
      end
      
      def error_bruteforce
        raise Ricer4::ExecutionException.new(bruteforce_message)
      end

      def bruteforce_message
        tt('ricer4.extend.bruteforce_protected.err_bruteforce', time: display_timeout)
      end
      
      def register_attempt
        @BF_TRIES[sender] = Time.now.to_f + timeout
      end
      
      def clear_tries
        @BF_TRIES.each do |k,v|
          @BF_TRIES.delete(k) if v < Time.now.to_f
        end
      end
      
    end
  end
end
