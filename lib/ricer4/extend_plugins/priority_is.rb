module Ricer4::Extend::PriorityIs
  def priority_is(priority)
    class_eval do |klass|
      
      unless priority.integer? && priority.between?(1, 100)
        throw StandardError.new("#{klass.name} priority_is is not between 1 and 100: #{priority}")
      end
  
      klass.define_class_variable(:@priority, priority)
      
      def plugin_priority
        get_class_variable(:@priority)
      end
      
    end
  end
end
