module Ricer4
  class Plugin < ActiveRecord::Base
    
    self.table_name = "ricer_plugins"
    
    arm_cache
    arm_named_cache(:name)
    
    arm_events
    
    arm_install() do |migration|
      migration.create_table(table_name) do |t|
        t.string   :name,     :null => false, :limit => 64, :charset => :ascii, :collation => :ascii_bin, :unique => true
        t.integer  :revision, :null => false, :limit =>  3, :default => 0, :unsigned => true
        t.timestamps :null => false
      end
    end

    arm_install('ActiveRecord::Magic::Permission' => 1) do |migration|
      arm_permissions(:public, :registered, :confirmed, :authenticated, :voice, :halfop, :operator, :admin, :ircop, :owner, :responsible)
      arm_group(:user, :public)
      arm_group(:member, :public, :registered, :confirmed)
      arm_group(:voice, :public, :voice)
      arm_group(:halfop, :public, :voice, :halfop)
      arm_group(:operator, :public, :voice, :halfop, :operator)
      arm_group(:admin, :public, :voice, :halfop, :operator, :admin)
      arm_group(:founder, :public, :voice, :halfop, :operator, :admin, :founder)
      arm_group(:ircop, :public, :voice, :halfop, :operator, :admin, :founder, :ircop)
      arm_group(:responsible, :public, :voice, :halfop, :operator, :admin, :founder, :ircop, :responsible)
    end
    
    # def self.plugin_module_object; @plugin_module_object ||= Object.const_get(name.deconstantize); end
    # def self.plugin_module; @plugin_module ||= name.split('::')[-2]; end
    # def self.plugin_name; @plugin_name ||= name.split('::')[-2..-1].join('/'); end
    # def plugin_module_object; self.class.plugin_module_object; end
    # def plugin_module; self.class.plugin_module; end
    # def plugin_name; self.class.plugin_name; end
    
    # def plugin_date; '2015-11-09T13:37:42Z'; end
    # def plugin_author; 'gizmore@wechall.net'; end
    # def plugin_version; 1; end
    # def plugin_license; :RICED; end
    # def plugin_priority; 50; end
    # def plugin_trigger; nil; end
    # def plugin_description(long); t!(:description) rescue nil; end
    # def plugin_init; end

  end
end