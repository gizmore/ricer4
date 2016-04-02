module Ricer4::Plugins::Todo
  module Model
    class Entry < ActiveRecord::Base
      
      include Ricer4::Include::Readable
  
      self.table_name = 'todo_entries';
      
      arm_install do |m|
        m.create_table self.table_name do |t|
          t.string    :text,       :null => false
          t.integer   :priority,   :null => false, :default => 0,  :limit => 3
          t.integer   :worker_id,  :null => true,  :default => nil
          t.integer   :creator_id, :null => false
          t.timestamp :done_at,    :null => true,  :default => nil
          t.timestamp :deleted_at, :null => true,  :default => nil
          t.timestamps :null => false
        end
      end
  
      scope :open, -> { where("#{table_name}.deleted_at IS NULL")}
      scope :closed, -> { where("#{table_name}.deleted_at IS NOT NULL")}

      def self.visible(user); where("deleted_at IS NULL"); end
    
      ##################
      ### Searchable ###
      ##################
      search_syntax do
        search_by :text do |scope, phrases|
          columns = [:id, :text]
          scope.where_like(columns => phrases)
        end
      end
  
      ##################
      ### Connectors ###
      ##################
      def worker
        Ricer4::User.by_id(self.worker_id)
      end
      
      def creator
        Ricer4::User.by_id(self.creator_id)
      end
      
      def display_date
        I18n.l(self.created_at, format: :long_date)
      end
  
      def display_time
        human_age(self.done_at)
      end
  
      def show_item()
        I18n.t!('.ricer4.plugins.todo.show_item',
          id: self.id,
          text: self.text,
          creator: self.creator.display_name,
          date: self.display_date
        )
      end
      
      def display_list_item(number)
        self.list_item(number)
      end
  
      def list_item(number)
        I18n.t('ricer4.plugins.todo.list_item',
          id: number,
          text: self.text,
          creator: self.creator.display_name,
          date: self.display_date,
          priority: self.priority
        )
      end
      
      def display_show_item(number)
        display_item(number)
      end
      def display_item(number)
        I18n.t('ricer4.plugins.todo.display_item',
          n: number,
          id: self.id,
          text: self.text,
          creator: self.creator.display_name,
          date: self.display_date,
          priority: self.priority
        )
      end
      
      def display_take(number=1)
        if self.deleted_at; key = 'deleted'
        elsif self.done_at; key = 'solved'
        elsif self.worker_id; key = 'taken'
        else; key = 'created'
        end
        # key = self.done_at.nil? ? 'taken' : 'solved'
        I18n.t("ricer4.plugins.todo.#{key}_item",
          n: self.id,
          id: self.id,
          text: self.text,
          creator: self.creator.display_name,
          worker: self.worker.display_name,
          time: self.display_time,
          priority: self.priority
        )
      end
      
    end
  end
end
