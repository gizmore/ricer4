module Ricer4::Plugins::Stats
  class TriggerCounter < ActiveRecord::Base
    
    # belongs_to :plugin, :class_name => 'Ricer4::Plugin'
    # belongs_to :user, :class_name => 'Ricer4::User'
    
    def self.upgrade_1
      return if table_exists?
      m = ActiveRecord::Migration.new
      m.create_table table_name do |t|
        t.integer :plugin_id, :null => false
        t.integer :user_id,   :null => false
        t.integer :calls,     :null => false, :default => 0, :unsigned => true
      end
      m.add_index table_name, [:plugin_id, :user_id], unique: true, name: :plugin_user_calls_index
      m.add_foreign_key table_name, :users,   :on_delete => :cascade
      m.add_foreign_key table_name, :plugins, :on_delete => :cascade
    end
    
    scope :summed, -> { select("SUM(#{table_name}.calls) AS sum") }
    scope :for_user, lambda { |user| where(:user_id => user.id) }
    scope :for_plugin, lambda { |plugin| where(:plugin_id => plugin.id) }
    
    def self.count(plugin_id, user_id)
      counter = get_counter(plugin_id, user_id)
      counter.calls += 1
      counter.save!
      counter
    end
    
    @@cache = {}
    def self.get_counter(plugin_id, user_id)
      @@cache["#{plugin_id}.#{user_id}"] ||=
        where(:plugin_id => plugin_id, :user_id => user_id).first ||
        new({:plugin_id => plugin_id, :user_id => user_id, :calls => 0})
    end
    
  end
end
