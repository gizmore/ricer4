module Ricer4::Plugins::Board
  class Board < Ricer4::Plugin
    
    has_setting name: :interval, type: :duration, scope: :bot, permission: :responsible, min: 2.seconds, max: 2.hour, default: 10.seconds
    
    default_enabled
    
    ##########################
    ### Announcement timer ###
    ##########################
    def plugin_init
      arm_subscribe('ricer/ready') do
        service_threaded do
          loop do
            sleep get_setting(:interval)
            if plugin_enabled?
              Model::Board.enabled.find_each do |board|
                check_board(board)
              end
            end
          end
        end
      end
    end
    
    def check_board(board)
      bot.log.debug("Board/Board#check_board(#{board.url})")
      begin
        board.fetch_entries!.each do |entry|
          announce_entry(board, entry)
        end
      rescue StandardError => e
        send_exception(e)
      end
    end
    
    def announce_entry(board, entry)
      bot.log.debug("Board/Board#announce_entry(#{entry.inspect})")
      board.abbo_targets.each do |target|
        target.localize!.send_message(announce_message(board, entry))
      end
    end
    
    def announce_message(board, entry)
      I18n.t(:msg_announce, name: board.name, entry: entry.display_entry)
    end
    
  end
end
