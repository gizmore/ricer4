module Ricer4
  class Server < ActiveRecord::Base
    
    self.table_name = 'ricer_servers'

    PLAINTEXT ||= 0
    SSL_1_0   ||= 1
    TLS_3_0   ||= 2
    
    include Ricer4::Include::OnlineRecord
    include Ricer4::Include::LocalizedRecord
    
    arm_cache
    arm_events

    attr_reader :connection, :nickname_prefix
    
    ###############
    ### Install ###
    ###############
    arm_install('ActiveRecord::Magic::Timezone' => 1, 'ActiveRecord::Magic::Locale' => 1, 'ActiveRecord::Magic::Encoding' => 1) do |m|
      # Database
      m.create_table(table_name) do |t|
        t.string  :conector,    :default => nil,   :null => false, :limit => 16, :charset => :ascii, :collation => :ascii_bin
        t.string  :name,        :default => nil,   :null => true,  :limit => 128
        t.string  :hostname,    :default => nil,   :null => true,  :limit => 255
        t.integer :port,        :default => nil,   :null => true,  :limit => 2,  :unsigned => true
        t.integer :tls,         :default => 0,     :null => true,  :limit => 1,  :unsigned => true
        t.string  :username,    :default => nil,   :null => true,  :limit => 64
        t.string  :userhost,    :default => nil,   :null => true,  :limit => 128
        t.string  :realname,    :default => nil,   :null => true,  :limit => 96
        t.string  :nickname,    :default => nil,   :null => true,  :limit => 64
        t.string  :user_pass,   :default => nil,   :null => true,  :limit => 64
        t.string  :server_pass, :default => nil,   :null => true,  :limit => 64
        t.string  :triggers,    :default => nil,   :null => true,  :limit => 4
        t.integer :locale_id,   :default => 1,     :null => true
        t.integer :encoding_id, :default => 1,     :null => true
        t.integer :timezone_id, :default => 1,     :null => true
        t.boolean :enabled,     :default => true,  :null => false
        t.boolean :online,      :default => false, :null => false
        t.timestamps :null => false
      end
    end
    
    arm_install do |m|
      m.add_foreign_key table_name, :arm_locales,   :column => :locale_id,   :on_delete => :nullify
      m.add_foreign_key table_name, :arm_encodings, :column => :encoding_id, :on_delete => :nullify
      m.add_foreign_key table_name, :arm_timezones, :column => :timezone_id, :on_delete => :nullify
    end
    
    ################
    ### Relation ###
    ################
    def users; Ricer4::User.where(:server_id => self.id); end
    def channels; Ricer4::Channel.where(:server_id => self.id); end
    
    #############
    ### Scope ###
    #############    
    def self.enabled; where("enabled = ?", true); end

    ##############
    ### Limits ###
    ##############
    def max_line_length; @max_line_length||460; end
    def max_line_length=(length); @max_line_length = [length.to_i, 16].max; end
    
    ##############
    ### Config ###
    ##############
    def get_triggers; self.triggers || bot.config.triggers; end
    def get_nickname; self.nickname || bot.config.nickname; end
    def get_username; self.username || bot.config.username; end
    def get_userhost; self.userhost || bot.config.userhost; end
    def get_realname; self.realname || bot.config.realname; end
  
    ######################
    ### Name from Host ###
    ######################
    before_save :set_server_name
#    def name=(name); super(name); set_server_name; end
    def set_server_name; self.name = domain; end

    ###############
    ### Display ###
    ###############
    def url; "#{connector.protocol}://#{hostname}:#{port}"; end
    def display_name; hostname; end
    
    ##############
    ### Helper ###
    ##############
    def uri; URI(url); end
    def tls?; self.tls > 0; end
    def domain; uri.domain; end

    #################
    ### Nicknames ###
    #################
    def next_nickname; get_nickname + (@nickname_prefix||''); end    
    def next_nickname!; @nickname_prefix = ("_"+random_token(5)); end
    def nick_authenticate?; @nickname_prefix.nil? && (user_pass != nil); end
    
    #####################
    ### Communication ###
    #####################
    def connector; @connector ||= _connector; end
    def _connector; Ricer4::Connector.by_name(self.conector).new(self); end
    def connect!; connector.connect!; end
    def send_line(line); send_reply(Ricer4::Reply.new(line)); end
    def send_reply(reply); arm_publish("ricer/reply", reply); connector.send_reply(reply); arm_publish("ricer/replied", reply); end

  end
end
