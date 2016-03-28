module Ricer4::Plugins::Note
  class Message < ActiveRecord::Base
    
    self.table_name = :note_messages
    
    belongs_to :sender, :class_name => 'Ricer4::User'
    belongs_to :receiver, :class_name => 'Ricer4::User'
    
    def self.inbox(user); where(receiver_id: user.id); end
    def self.outbox(user); where(sender_id: user.id); end
    def self.visible(user); where("#{table_name}.sender_id=#{user.id} OR #{table_name}.receiver_id=#{user.id}"); end
    def self.unread; where("#{table_name}.read_at IS NULL"); end
    def self.read; where("#{table_name}.read_at IS NOT NULL"); end
    def read?; self.read_at != nil; end
    def unread?; self.read_at == nil; end
    
    validates :message, :length => { minimum: 1, maximum: 1024 }
        
    def self.upgrade_1
      return if table_exists?
      m = ActiveRecord::Migration
      m.create_table table_name do |t|
        t.integer   :sender_id,    :null => false
        t.integer   :receiver_id,  :null => true
        t.string    :message,      :null => false, :length => 1024
        t.datetime  :read_at,      :null => true
        t.timestamp :created_at,   :null => false
      end
      m.add_foreign_key table_name, :users,       :name => :note_senders,   :column => :sender_id,   :on_delete => :cascade 
      m.add_foreign_key table_name, :users,       :name => :note_receivers, :column => :receiver_id, :on_delete => :cascade 
      m.add_index       table_name, :sender_id,   :name => :note_sender_index
      m.add_index       table_name, :receiver_id, :name => :note_receiver_index
    end
    
    search_syntax do
      search_by :text do |scope, phrases|
        scope.joins(:sender).where_like(['users.name', :message] => phrases)
      end
      search_by :sender do |scope, phrases|
        scope.joins(:sender).where_like(['users.name'] => phrases)
      end
      search_by :sender do |scope, phrases|
        scope.joins(:receiver).where_like(['users.name'] => phrases)
      end
      search_by :message do |scope, phrases|
        scope.where_like([:message] => phrases)
      end
      search_by :id do |scope, phrases|
        scope.where([:id] => phrases)
      end
    end

    def display_list_item(number)
      I18n.t('ricer3.plugins.note.list_item', id: number, from: self.sender.display_name, unread: unread_bold)
    end
    
    def unread_bold
      self.read? == false ? "\x02" : ''
    end

    def display_show_item(number=1)
      mark_read
      I18n.t('ricer3.plugins.note.show_item',
        from: self.sender.display_name,
        date: self.display_date,
        text: self.message
      )
    end
    
    def mark_read
      self.read_at = Time.now
      self.save!
    end
    
    def display_date
      I18n.l(self.created_at)
    end
    
  end
end