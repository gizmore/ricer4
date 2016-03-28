load File.expand_path("../consumable.rb", __FILE__)
module Ricer4::Plugins::Shadowlamb::Core::Items
  class Drink < Consumable
  
    def consume
      broadcast('player/consumed/drink', owner, self)
    end
      
  end
end
