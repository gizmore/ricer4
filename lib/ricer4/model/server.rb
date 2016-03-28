module Ricer4
  class Server < ActiveRecord::Base
    
    self.table_name = 'ricer_servers'
    
    arm_cache
    
    arm_install('ActiveRecord::Magic::Timezone' => 1, 'ActiveRecord::Magic::Locale' => 1, 'ActiveRecord::Magic::Encoding' => 1) do |migration|
      migration.create_table(table_name) do |t|
        t.string  :conector,    :default => 'irc', :null => false, :limit => 16, :charset => :ascii, :collation => :ascii_bin
        t.string  :name,        :default => nil,   :null => true,  :limit => 128
        t.string  :hostname,    :default => nil,   :null => true,  :limit => 128
        t.integer :port,        :default => 6667,  :null => true,  :limit => 2,  :unsigned => true
        t.integer :tls,         :default => 0,     :null => true,  :limit => 1,  :unsigned => true
        t.string  :username,    :default => nil,   :null => true,  :limit => 64
        t.string  :userhost,    :default => nil,   :null => true,  :limit => 128
        t.string  :realname,    :default => nil,   :null => true,  :limit => 64
        t.string  :nickname,    :default => nil,   :null => true,  :limit => 64
        t.string  :user_pass,   :default => nil,   :null => true,  :limit => 64
        t.string  :server_pass, :default => nil,   :null => true,  :limit => 64
        t.string  :triggers,    :default => bot.config.trigger, :null => false, :limit => 4
        t.integer :locale_id,   :default => 1,     :null => true
        t.integer :encoding_id, :default => 1,     :null => true
        t.integer :timezone_id, :default => 1,     :null => true
#        t.integer :throttle,    :default => 4,     :null => true, :limit => 2, :unsigned => true
#          t.float   :cooldown,    :default => 0.5,   :null => false
        t.boolean :enabled,     :default => true,  :null => false
        t.boolean :online,      :default => false, :null => false
        t.timestamps :null => false
      end
      migration.add_foreign_key table_name, :arm_locales, :column => :locale_id
      migration.add_foreign_key table_name, :arm_encodings, :column => :encoding_id
      migration.add_foreign_key table_name, :arm_timezones, :column => :timezone_id
    end
    
  end
end