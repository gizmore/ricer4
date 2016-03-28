module Ricer4::Plugins::Todo
  class Done < Ricer4::Plugin

    trigger_is 'todo.done'

    has_usage '<id>'
    def execute(id)
      solve_todo_entry(Model::Entry.find(id))
    end
    
    def solve_todo_entry(entry)
      
      # already done
      return rply(:err_already_done, worker: entry.worker.display_name, id: entry.id) if entry.done_at
      
      # update to solved
      entry.done_at = Time.now
      entry.worker_id = sender.id
      entry.save! # exception!
      
      # reply
      rply(:msg_done,
        id: entry.id,
        creator: entry.creator.display_name,
        worker: entry.worker.display_name,
        text: entry.text,
        time: entry.display_time)

      # announce
      arm_publish('todo/entry/done', entry)
    end
    
  end
end
