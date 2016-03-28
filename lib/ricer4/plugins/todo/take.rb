module Ricer4::Plugins::Todo
  class Take < Ricer4::Plugin
    trigger_is 'todo.take'
    
    has_usage '<id>'
    def execute(id)
      take_entry(Model::Entry.find(id))
    end
    
    def take_entry(entry)
      if entry.nil?
        return raise ActiveRecord::RecordNotFound
      end
      if (entry.worker)
        rply(:err_already_taken, id: entry.id, worker: entry.worker.display_name)
      else
        entry.worker_id = sender.id
        entry.save!
        reply entry.display_take
        arm_publish('todo/entry/taken', entry)
      end
    end

  end
end
