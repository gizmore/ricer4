module Ricer4::Include::HasEnum
  def self.included base
    base.send :include, InstanceMethods
    base.extend ClassMethods
  end

  module InstanceMethods
  end

  module ClassMethods
    def has_enum(enums)
      class_eval do |klass|
        # enums.each do |key,options|
          # #klass.send(:remove_method, :"#{key}")
          # klass.remove_possible_method :"#{key}="
          # klass.remove_possible_method :"#{key}="
          # options.each do |option|
            # # klass.send(:remove_method, "#{option}") if klass.respond_to?("#{option}")
            # # klass.send(:remove_method, "#{option}?") if klass.respond_to?("#{option}?")
            # # klass.send(:remove_method, "#{option}!") if klass.respond_to?("#{option}!")
          # end
        # end
        klass.enum enums rescue nil
      end
    end
  end
  
end
