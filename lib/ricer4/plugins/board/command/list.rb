module Ricer4::Plugins::Board
  class List < Ricer4::Plugin
    
    is_list_trigger 'list', :for => Ricer4::Plugins::Board::Model::Board

    
  end
end
