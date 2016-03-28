module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Negotiation < ValueType::Skill
    
    arm_subscribe('filter/shop/items') do |player, items|
      byebug
    end
    
  end
end
