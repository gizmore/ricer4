module Ricer4::Plugins::Poll
  class Answer < ActiveRecord::Base
    
    self.table_name = 'poll_answers'
    
    belongs_to :user,   :class_name => 'Ricer4::User'
    belongs_to :option, :class_name => "Ricer4::Plugins::Poll::Option"
    
    def self.upgrade_1
      return if table_exists?
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.integer   :user_id,    :null => false
        t.integer   :option_id,  :null => false
        t.timestamp :created_at, :null => false
      end
    end
    
  end
end
