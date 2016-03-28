module Ricer4::Plugins::Todo
  class Show < Ricer4::Plugin
    
    is_show_trigger 'todo.show', :for => Ricer4::Plugins::Todo::Model::Entry

  end
end
