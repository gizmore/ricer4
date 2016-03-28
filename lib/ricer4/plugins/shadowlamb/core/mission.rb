module Ricer4::Plugins::Shadowlamb::Core
  class Mission < ActiveRecord::Base

    self.table_name = 'sl5_missions'
#    arm_cache; def should_cache?; true; end

    include Include::Base
    include Include::Translates
    arm_events
    
    belongs_to :quest,  :class_name => Quest.name
    belongs_to :player, :class_name => Player.name
    
    STATES ||= [UNKNOWN = 0, KNOWN = 1, ACCEPTED = 2, DENIED = 3, FAILED = 4, ACCOMPLISHED = 5]
    
    # validates_presence_of :quest
    # validates_presence_of :player
    validates_numericality_of :status, :only_integer => true, :greater_than => -1, :less_than => 6
        
    ###############
    ### Install ###
    ###############
    def self.upgrade_1
      unless ActiveRecord::Base.connection.table_exists?(table_name)
        m = ActiveRecord::Migration.new
        m.create_table table_name do |t|
          t.integer :quest_id,  :null => false
          t.integer :player_id, :null => false
          t.integer :status,    :null => false, :limit => 1, :unsigned => true, :default => 1
          t.timestamps :null => false
        end
      end
    end

    def self.upgrade_2
      m = ActiveRecord::Migration.new
      m.add_foreign_key table_name, :sl5_quests,  :name => :mission_quest,    :column => :quest_id,  :on_delete => :cascade rescue nil
      m.add_foreign_key table_name, :sl5_players, :name => :mission_player,   :column => :player_id, :on_delete => :cascade rescue nil
      m.add_index       table_name, [:player_id, :quest_id], :name => :players_missions, :unique => true rescue nil
    end
    
    #############
    ### Scope ###
    #############
    def self.denied; where(:status => DENIED); end
    def self.failed; where(:status => FAILED); end
    def self.accepted; where(:status => ACCEPTED); end
    def self.accomplished; where(:status => ACCOMPLISHED); end

    ##############
    ### Values ###
    ##############
    def accept
      self.status = ACCEPTED
      self.save!
      self.quest.broadcast('mission/accept', self.player, self)
      self.player.localize!.send_msg("shadowlamb.quest.msg_quest_accepted", quest: self.display_name, info: self.displayinfo, accept: self.display_accept)
      self.player.broadcast('player/mission/accepted', self.player, self)
      self.quest.broadcast('mission/accepted', self.player, self)
    end

    def set_value(key, value)
      missionVar.find_or_create_by(:mission_id => self.id, :name => key).set_value(value)
    end
    
    def get_value(key, default=nil)
      missionVar.find_by(:mission_id => self.id, :name => key).get_value() rescue default
    end
    
    ###############
    ### Display ###
    ###############
    def display_list_item(number)
      self.quest.display_list_item(number)
    end

    def display_show_item(number)
      self.quest.display_show_item(number)
    end
    
    def display_name
      self.quest.display_name
    end
    
    def displayinfo
      self.quest.displayinfo
    end
    
    def display_accept
      self.quest.display_accept
    end
    
  end
end
