module Ricer4::Plugins::Seen
  class Said < ActiveRecord::Base
    
    self.table_name = :seen_messages
    
    def user; Ricer4::User.find(self.user_id); end
    def channel; self.channel_id ? Ricer4::Channel.find(self.channel_id) : nil; end

    def self.upgrade_1
      return if table_exists?
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.integer :user_id,    :null => false, :unsigned => true
        t.integer :channel_id, :null => false, :unsigned => true
        t.string  :message,    :null => false
      end
    end
    
  end
end
