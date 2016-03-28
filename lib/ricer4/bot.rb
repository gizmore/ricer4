module Ricer4
  class Bot
    
    attr_reader :config, :log, :loader, :running
    
    def self.instance; @@instance; end
    
    def initialize(config_path)
      @@instance = self
      @log = arm_log
      @config = ActiveRecord::Magic::Config.new(config_path)
      @loader = Ricer4::PluginLoader.new
      @running = true
    end
    
    def core_directory
      File.dirname(__FILE__)
    end
    
    def db_connect
      @config.database ||= { pool: 10, adapter: 'mysql2', encoding: 'utf8', database: 'arm_test', username: 'arm_test', password: 'arm_test' }
      ActiveRecord::Magic::Base.arm_connect(@config.database)
    end
    
    def install
      ActiveRecord::Magic::Update.install
    end
    
    def upgrade
      ActiveRecord::Magic::Update.run
    end
    
    def load_plugins
      Filewalker.proc_dirs(core_directory+"/plugins") do |file,dir|
        @loader.add_directory(dir)
      end
      @loader.load_i18n
      @loader.load_plugins
    end
    
    def mainloop
      while @running
        step
      end
    end
    
    def step
      Ricer4::Server.arm_get_cache.each do |server|
        step_for(server)
      end
    end
    
    def step_for(server)
      
    end
    
    def exec_argv(argv)
      exec_line(argv.join(" "))
    end
    
    def exec_line(line)
      
    end
        
  end
end