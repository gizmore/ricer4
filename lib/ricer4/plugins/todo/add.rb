module Ricer4::Plugins::Todo
  class Add < Ricer4::Plugin
    
    trigger_is 'todo.add'
    
    has_usage '<string|named:"todo_text">'
    def execute(todo_text)
      entry = Ricer4::Plugins::Todo::Model::Entry.new({
        text: todo_text,
        creator_id: sender.id,
        priority: 0,
      })
      entry.save!
      reply(entry.display_item(entry.id))
      arm_publish('todo/entry/added', entry)
    end
    
  end
end
