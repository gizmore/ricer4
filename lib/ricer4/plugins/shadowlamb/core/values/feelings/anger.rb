module Ricer4::Plugins::Shadowlamb::Core
  class ValueType::Anger < ValueType::Feeling
  
    arm_subscribe('player/sleeping') do |player, elapsed|
      player.add_feeling(:anger, -elapsed.to_i)
    end
    
    arm_subscribe('player/tick/minute') do |player, elapsed|
      player.add_feeling(:anger, -elapsed.to_i)
    end

  end
end
