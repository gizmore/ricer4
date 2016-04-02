module Ricer4
  module Extend
    module Base
      
      def bot; Ricer4::Bot.instance; end
      
    end
  end
end

Object.extend Ricer4::Extend::Base
Object.send :include, Ricer4::Extend::Base