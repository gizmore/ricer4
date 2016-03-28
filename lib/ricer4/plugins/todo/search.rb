module Ricer4::Plugins::Todo
  class Search < Ricer4::Plugin
    
    is_search_trigger 'todo.search',
      :for => Ricer4::Plugins::Todo::Model::Entry,
      :per_page => 5
    
    def execute(entry)
      show(entry)
    end
    
    def show(entry)
      reply(entry.display_item(entry.id))
    end

    def order_relation(relation)
      relation.order("priority desc")
    end

  end
end
