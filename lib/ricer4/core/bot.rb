load "ricer4/core/mainloop.rb"

module Ricer4
  class Bot
    
    include Ricer4::Mainloop
    
    arm_events
    
    attr_reader   :config, :log, :loader, :rand, :parser
    attr_accessor :running
    
    def self.instance; @@instance; end
    
    def servers; Ricer4::Server; end
    def users; Ricer4::User.all; end
    
    def uptime
      (Time.new - @uptime).to_f 
    end
    
    def initialize(config_path)
      @@instance = self
      @log = arm_log
      configure(config_path)
      @rand = Random.new(@config.seed)
      @loader = Ricer4::PluginLoader.new(@config)
      @parser = Ricer4::CommandParser.new
      @running = true
      @uptime = Time.new
      add_plugin_dirs
    end
    
    def configure(config_path)
      @config = ActiveRecord::Magic::Config.new(config_path)
      @config.triggers ||= '!'
      @config.nickname ||= 'ricer4'
      @config.username ||= 'ricer'
      @config.userhost ||= 'ricer4.gizmore.org'
      @config.realname ||= 'Richard Ricer'
      @config.seed ||= 31337
      @config.blacklist ||= ['Plugin/Name', 'Another/Plugin']
      @config.database ||= { pool: 8, adapter: 'mysql2', encoding: 'utf8mb4', database: 'arm_test', username: 'arm_test', password: 'arm_test' }
      ActiveRecord::Magic::Mail.configure(@config);
    end
    
    def core_directory
      File.expand_path("../", File.dirname(__FILE__))
    end
    
    def db_connect
      ActiveRecord::Magic::Base.arm_connect(@config.database)
    end
    
    def add_plugin_dirs
      add_core_plugin_dirs
      arm_publish('ricer/add_plugin_dirs', @loader)
    end

    def add_core_plugin_dirs
      Filewalker.proc_dirs(core_directory+"/plugins") do |file,dir|
        @loader.add_directory(dir) 
      end
    end
    
    def load_plugins
      bot.log.debug("Ricer4::Bot.load_plugins")
      @loader.load_i18n
      @loader.load_plugins
    end
    
    ############################
    ### THIS IS ONLY SPEC ##
    ### SPEC ONLY! #######
    ##################
    ### Exec faker ###
    ##################
    def exec_server; Ricer4::Server.where(:conector => 'shell').first; end
    def exec_connector; exec_server.connector; end
    def exec_output; exec_connector.tty_output; end
    
    def exec_line(line)
      result = nil
      exec_connector.clear_tty_output
      exec_line_yielder(line){|text|
        result = text
      }
      result
    end

    def exec_line_for(plugin_name, line="")
      I18n.locale = 'bot'
      plugin = @loader.get_plugin!(plugin_name)
      line = line.empty? ? "" : " #{line}"
      exec_line "#{plugin.plugin_trigger}#{line}"
    end
    
    def exec_line_yielder(line, &block)
      hook = arm_subscribe('ricer/command/finished') { |command|
        yield command.sent_replies.collect{|reply| reply.text }.join("\n")
      }
      server = Ricer4::Server.where(:conector => 'shell').first
      server.connector.send_from_tty(line)
      Thread.list.tap{|t|t.shift;}.each{|t|t.join}
      hook.remove
    end
    
    #####################
    ### Exec as faker ###
    #####################
    def exec_user=(username)
      server = Ricer4::Server.where(:conector => 'shell').first
      server.connector.tty_user_name = username
    end
    
    def exec_user(username)
      self.exec_user=username
      exec_connector.get_tty_sender
    end

    def exec_as(username, &block)
      self.exec_user=(username)
      yield
    end

    def exec_line_as(username, line)
      exec_as(username) do 
        exec_line(line)
      end
    end

    def exec_line_as_for(username, plugin_name, line="")
      exec_as(username) do 
        exec_line_for(plugin_name, line)
      end
    end

  end
end