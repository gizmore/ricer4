load "ricer4/core/mainloop.rb"

module Ricer4
  class Bot
    
    include Ricer4::Mainloop
    
    arm_events
    
    attr_reader :config, :log, :loader, :running, :rand, :parser
    
    def self.instance; @@instance; end
    
    def initialize(config_path)
      @@instance = self
      @log = arm_log
      @config = ActiveRecord::Magic::Config.new(config_path)
      configure
      @rand = Random.new(@config.seed)
      @loader = Ricer4::PluginLoader.new(@config)
      @parser = Ricer4::CommandParser.new
      @running = true
    end
    
    def name
      @config.nickname
    end
    
    def configure
      @config.seed ||= 31337
      @config.blacklist ||= ['Plugin/Name', 'Another/Plugin']
      ActiveRecord::Magic::Mail.configure(@config);
    end
    
    def core_directory
      File.expand_path("../", File.dirname(__FILE__))
    end
    
    def db_connect
      @config.database ||= { pool: 10, adapter: 'mysql2', encoding: 'utf8', database: 'arm_test', username: 'arm_test', password: 'arm_test' }
      ActiveRecord::Magic::Base.arm_connect(@config.database)
    end
    
    def load_plugins
      Filewalker.proc_dirs(core_directory+"/plugins") do |file,dir|
        @loader.add_directory(dir)
      end
      @loader.load_i18n
      @loader.load_plugins
    end
    
    def exec_argv(argv)
      exec_line(argv.join(" "))
    end
    
    def exec_line(line)
      result = nil
      exec_line_yielder(line){|text| result = text }
      result
    end
    
    def exec_line_yielder(line, &block)
      arm_subscribe('ricer/command/finished') { |command|
        yield command.sent_replies.collect{|reply| reply.text }.join("\n")
      }.max_calls(1)
      server = Ricer4::Server.where(:conector => 'shell').first
      server.connector.send_from_tty(line)
    end
        
  end
end