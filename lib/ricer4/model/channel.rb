module Ricer4
  class Channel < ActiveRecord::Base
    
    self.table_name = 'ricer_channels'
    
    arm_cache
    
    arm_install('ActiveRecord::Magic::Timezone' => 1, 'ActiveRecord::Magic::Locale' => 1, 'ActiveRecord::Magic::Encoding' => 1, 'Ricer4::Server' => 1) do |migration|
      migration.create_table(table_name) do |t|
        t.integer :server_id
        t.string  :name
        t.string  :password,    :default => nil,   :null => true,  :limit => 64
        t.string  :triggers,    :default => nil,   :null => true,  :length => 4
        t.integer :locale_id,   :default => nil,   :null => true
        t.integer :timezone_id, :default => nil,   :null => true
        t.integer :encoding_id, :default => nil,   :null => true
        t.boolean :colors,      :default => true
        t.boolean :decorations, :default => true
        t.boolean :online,      :default => false, :null => false
        t.timestamps :null => false
      end
      migration.add_index table_name, :name, name: :channels_name_index
      migration.add_index table_name, :server_id, name: :channels_server_index
      migration.add_foreign_key table_name, :ricer_servers, :column => :server_id, :on_delete => :cascade
      migration.add_foreign_key table_name, :arm_locales, :column => :locale_id
      migration.add_foreign_key table_name, :arm_encodings, :column => :encoding_id
      migration.add_foreign_key table_name, :arm_timezones, :column => :timezone_id
    end
    
  end
end
