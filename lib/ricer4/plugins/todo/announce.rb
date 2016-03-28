module Ricer4::Plugins::Todo
  class Announce < Ricer4::Plugin
    
    is_announce_trigger "todo.announce"
    
    def plugin_init

      arm_subscribe('todo/entry/added') do |entry|
        announce_targets(true) do |target|
          target.localize!.send_privmsg(entry.display_item(entry.id))
        end
      end
      
      arm_subscribe('todo/entry/taken') do |entry|
        announce_targets(true) do |target|
          target.localize!.send_privmsg(entry.display_take)
        end
      end

      arm_subscribe('todo/entry/done') do |entry|
        announce_targets(true) do |target|
          target.localize!.send_privmsg(entry.display_take)
        end
      end

    end

  end
end
