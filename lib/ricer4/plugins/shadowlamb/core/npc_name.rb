module Ricer4::Plugins::Shadowlamb::Core
  class NpcName < ActiveRecord::Base
  
    self.table_name = 'sl5_npcs'
    
    arm_cache; def should_cache?; true; end
    
    include Include::Base
    
    def self.upgrade_1
      unless ActiveRecord::Base.connection.table_exists?(table_name)
        m = ActiveRecord::Migration.new
        m.create_table table_name do |t|
          t.string :npc_path, :null => false, :limit => 96, :collation => :ascii_bin, :charset => :ascii
        end
      end
    end
    def self.upgrade_2
      m = ActiveRecord::Migration.new
      m.add_index table_name, :npc_path, :unique => true, :name => :unique_npc_pathes rescue nil
    end
   
    def self.register_npc(npc_path, npc_klass)
      npc_name = self.find_or_create_by(:npc_path => npc_path)
      bot.log.info("Registered NPC: #{npc_path} as #{npc_klass.name}")
      npc_name.id
    end
    
    def self.npc_id_for_path(npc_path)
      self.where(:npc_path => npc_path).first
    end

  end
end
