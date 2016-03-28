###
### Allows to deny multiple threads of a plugin for a user (or other scope)
###
### Example:
### denial_of_service_protected scope: :bot
###
### Ensures the execution can only be done once per bot instance.
### You need to call "stopped_service" to allow it again. 
###
module Ricer4::Extend::DenialOfServiceProtected
  
  DEFAULT_DOSP_OPTIONS ||= {
    max_threads: 1,
  }
  
  def denial_of_service_protected(options={})
    class_eval do |klass|

      ActiveRecord::Magic::Options.merge(options, DEFAULT_DOSP_OPTIONS)
      
      unless options[:max_threads].is_a?(Integer) && options[:max_threads].between?(1, 100)
        throw "#{klass.name} denial_of_service_protected max_threads is invalid and not between 1–100: #{options[:max_threads]}"
      end
    
      # Set option max
      klass.define_class_variable(:@dos_protection_max, options[:max_threads])

      # Set protection cache
#      klass.define_class_variable(:@dos_protection_cache, {})
      
      # Call this conviniently for a protected thread 
      def threaded(&block)
        start_service
        threaded_org do
          begin
            yield
          ensure
            stopped_service
          end
        end
      end

      protected

      # Call this when the thread is started!      
      def start_service
        denial_of_service_cache[service_issuer] ||= 0
        if service_running?
          raise Ricer::ExecutionException.new(tt('ricer3.extender.denial_of_service_protected.err_already_running'))  
        end
        denial_of_service_cache[service_issuer] += 1
      end
      
      # Call this when the thread is done!      
      def stopped_service
        denial_of_service_cache[service_issuer] -= 1
      end
      
      private
      
      def service_issuer
        sender.hostmask
      end
      
      def denial_of_service_max
        get_class_variable(:@dos_protection_max)
      end

      def denial_of_service_cache
        @@dos_cache ||= {}
#        get_class_variable(:@dos_protection_cache)
      end
      
      def service_running?
        denial_of_service_cache[service_issuer] >= denial_of_service_max
      end
      
    end
  end
end
