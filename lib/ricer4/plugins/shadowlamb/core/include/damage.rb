module Ricer4::Plugins::Shadowlamb::Core::Include::Damage
  
  def cause_damage(attacker, victim, with, damage)
    _cause_damage_to(attacker, victim, with, damage)
  end

  def cause_damages(with, attacker, damages={})
    damages.each do |victim,damage|
      _cause_damage_to(attacker, victim, with, damage)
    end 
  end

  def _cause_damage_to(attacker, victim, with, damage)
    begin
      broadcast('player/before/take_damage', attacker, victim, with, damage)
      broadcast('player/before/cause_damage', attacker, victim, with, damage)
      with.sl5_before_cause_damage(attacker, victim, with, damage)
      victim.sl5_before_take_damage(attacker, victim, with, damage)
      attacker.sl5_before_cause_damage(attacker, victim, with, damage)
      
      victim.add_hp(-damage)
      
      attacker.sl5_after_cause_damage(attacker, victim, with, damage)
      victim.sl5_after_take_damage(attacker, victim, with, damage)
      with.sl5_after_cause_damage(attacker, victim, with, damage)
      broadcast('player/after/cause_damage', attacker, victim, with, damage)
      broadcast('player/after/take_damage', attacker, victim, with, damage)
      
      if victim.dead?
        _cause_death_to(attacker, victim, with, damage)
      end
        
    rescue Ricer4::SilentCancelException => e
      bot.log.debug("_cause_damage_to(#{attacker.display_name}, #{victim.display_name}, #{with.display_name}, #{damage}): OOPS: silently cancelled")
    end
    
  end
  
  def _cause_death_to(attacker, victim, with, damage)
    attacker.party.ground.sl5_before_kill(attacker, victim, with, damage)
    with.sl5_before_killed(attacker, victim, with, damage)
    victim.sl5_before_killed(attacker, victim, with, damage)
    attacker.sl5_before_kill(attacker, victim, with, damage)
    broadcast('player/before/kill', attacker, victim, with, damage)
    broadcast('player/before/killed', attacker, victim, with, damage)
    
    # Reset attack lock
#    attacker.combat_stack.combat_target = nil
#    attacker.combat_stack.combat_command_lock = false
    # Respawn victim
    victim.respawn!
    
    broadcast('player/after/killed', attacker, victim, with, damage)
    broadcast('player/after/kill', attacker, victim, with, damage)
    attacker.sl5_after_kill(attacker, victim, with, damage)
    victim.sl5_after_killed(attacker, victim, with, damage)
    with.sl5_after_kill(attacker, victim, with, damage)
    attacker.party.ground.sl5_after_kill(attacker, victim, with, damage)
  end
  
end
