module Ricer4::Plugins::Todo
  class List < Ricer4::Plugin

    is_list_trigger "todo.list", :for => Model::Entry
    
  end
end
