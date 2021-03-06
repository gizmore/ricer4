module Ricer4::Plugins::Seen
  class Entry < ActiveRecord::Base
    
    self.table_name = :seen_entries
    
    def user; Ricer4::User.find(self.user_id); end
    def channel; self.channel_id ? Ricer4::Channel.find(self.channel_id) : nil; end

    arm_install do |m|
      m.create_table table_name do |t|
        t.integer :user_id,    :null => false, :unsigned => true
        t.integer :channel_id, :null => false, :unsigned => true
        t.string  :message,    :null => false
      end
    end
    
  end
end
