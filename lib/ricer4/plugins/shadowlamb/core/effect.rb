module Ricer4::Plugins::Shadowlamb::Core
  class Effect < ActiveRecord::Base
    
    self.table_name = 'sl5_effects'

    include Ricer4::Plugins::Shadowlamb::Core::Include::HasValues

    belongs_to :player, :class_name => Player.name
    
    def self.upgrade_1
      unless ActiveRecord::Base.connection.table_exists?(table_name)
        m = ActiveRecord::Migration.new
        m.create_table table_name do |t|
          t.integer :player_id, :null => false
          t.foreign_key :sl5_players, :name => :affected_players, :column => :player_id
        end
      end
    end
    
  end
end