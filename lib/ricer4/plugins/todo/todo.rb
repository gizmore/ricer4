module Ricer4::Plugins::Todo
  class Todo < Ricer4::Plugin
    
    author_is :gizmore
    license_is :MIT
    trigger_is :todo

    has_subcommands
    
    has_usage
    def execute
      get_plugin('Todo/Show').execute_show(Model::Entry.order_by_rand)
    end
    
  end
end    
