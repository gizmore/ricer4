module Ricer4
  class Plugin < ActiveRecord::Base
    
    self.table_name = "ricer_plugins"
    
    attr_accessor :plugin_dir    

    arm_i18n    
    arm_cache
    arm_named_cache(:name)
    arm_events
    
    include Ricer4::Include::Base
    include Ricer4::Include::Replies
    include Ricer4::Include::Readable
    include Ricer4::Include::Threaded
    include Ricer4::Include::ExecuteChains
    include Ricer4::Include::ChecksPermission
    
    arm_install do |migration|
      migration.create_table(table_name) do |t|
        t.string   :name,     :null => false, :limit => 64, :charset => :ascii, :collation => :ascii_bin, :unique => true
        t.integer  :revision, :null => false, :limit =>  3, :default => 0, :unsigned => true
        t.timestamps :null => false
      end
    end

    def self.plugin_module_object; @plugin_module_object ||= Object.const_get(name.deconstantize); end
    def self.plugin_module; @plugin_module ||= name.split('::')[-2]; end
    def self.plugin_name; @plugin_name ||= name.split('::')[-2..-1].join('/'); end
    def plugin_module_object; self.class.plugin_module_object; end
    def plugin_module; self.class.plugin_module; end
    def plugin_name; self.class.plugin_name; end
    
    def plugin_date; '2015-11-09T13:37:42Z'; end
    def plugin_author; 'gizmore@wechall.net'; end
    def plugin_version; 1; end
    def plugin_license; :RICED; end
    def plugin_priority; 50; end
    def plugin_trigger; nil; end
    def plugin_description(long); t!(:description) rescue plugin_default_description; end
    def plugin_default_description; "#{plugin_name} has no description."; end
    def plugin_init; end
    
    def get_plugin(plugin_name); self.class.get_plugin(plugin_name); end
    def self.get_plugin(plugin_name); bot.loader.get_plugin(plugin_name); end

  end
end
