module Ricer4::Plugins::Shadowlamb::Core
  class Profession < ActiveRecord::Base
    
    self.table_name = 'sl5_professions'

    include Ricer4::Plugins::Shadowlamb::Core::Include::HasValues
    
    belongs_to :player,          :class_name => Player.name
    belongs_to :profession_name, :class_name => ProfessionName.name
    
    delegate :to_label, :values, :to => :profession_name
    
    def self.upgrade_1
      unless ActiveRecord::Base.connection.table_exists?(table_name)
        m = ActiveRecord::Migration.new
        m.create_table table_name do |t|
          t.integer   :player_id,     :null => false
          t.integer   :profession_id, :null => false
          t.timestamp :created_at
        end
      end
    end

    def self.upgrade_2
      m = ActiveRecord::Migration.new
      m.add_foreign_key table_name, :sl5_players,          :name => :profession_players, :column => :player_id,     :on_delete => :cascade rescue nil
      m.add_foreign_key table_name, :sl5_profession_names, :name => :profession_names,   :column => :profession_id, :on_delete => :cascade rescue nil
    end
    
  end
end
