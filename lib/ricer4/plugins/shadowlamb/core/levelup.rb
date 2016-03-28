module Ricer4::Plugins::Shadowlamb::Core
  class Levelup < ActiveRecord::Base
    
    self.table_name = 'sl5_levelups'

    include Include::Base
    include Include::HasValues

    belongs_to :owner, :polymorphic => true
    
    def self.upgrade_1
      unless ActiveRecord::Base.connection.table_exists?(table_name)
        m = ActiveRecord::Migration.new
        m.create_table table_name do |t|
          t.integer :owner_id,   :null => false
          t.string  :owner_type, :limit => 128, :null => false, :charset => :ascii, :collation => :ascii_bin
        end
      end
    end

    def self.upgrade_2
      m = ActiveRecord::Migration.new
      m.add_index table_name, [:owner_id, :owner_type], :unique => true, :name => :lvlup_owners rescue nil
    end
    
  end
end