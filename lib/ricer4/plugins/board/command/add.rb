module Ricer4::Plugins::Board
  class Add < Ricer4::Plugin
    
    trigger_is "board.add"
    permission_is :owner

    denial_of_service_protected
    
    has_usage '<name> <url>'
    def execute(name, url)
      threaded {
        board = Model::Board.new({
          url: url,
          name: name,
        })
        board.validate!
        messages = board.test_protocol
        return rply :err_board unless messages
        board.save!
        rply(:msg_added,
          id: board.id,
          name: board.name,
          entry: messages.first.display_entry,
        )
      }
    end
    
  end
end
