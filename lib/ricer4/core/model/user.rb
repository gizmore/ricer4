require "bcrypt"

module Ricer4
  class User < ActiveRecord::Base
    
    self.table_name = 'ricer_users'

    include Ricer4::Include::OnlineRecord
    include Ricer4::Include::LocalizedRecord

    attr_accessor :hostmask

    #############
    ### Cache ###
    #############
    arm_cache
    arm_named_cache :guid, Proc.new{|user|"#{(user['name']||user[:name]).downcase}:#{user[:server_id]||user['server_id']}"}
    def arm_cache?; self.online == true; end

    #############
    ### Query ###
    #############
    def self.where_permission(bit); where("permission & #{bit}"); end
    
    ################
    ### Database ###
    ################
    arm_install() do |m|
      m.create_table table_name do |t|
        t.integer  :server_id,       :null => false
        t.string   :name,            :length => 64,     :null => false
        t.integer  :permissions,     :default => 0,     :null => false
        t.string   :hashed_password, :length  => 128,   :null => true
        t.string   :message_type,    :default => 'n',   :null => false, :length => 1, :charset => 'ascii', :collate => 'ascii_bin'
        t.integer  :locale_id,       :default => nil,   :null => true
        t.integer  :encoding_id,     :default => nil,   :null => true
        t.integer  :timezone_id,     :default => nil,   :null => true
        t.boolean  :online,          :default => false, :null => false
        t.timestamps :null => false
      end
    end

    arm_install('ActiveRecord::Magic::Locale' => 1, 'ActiveRecord::Magic::Encoding' => 1, 'ActiveRecord::Magic::Timezone' => 1, 'Ricer4::Server' => 1) do |m|
      m.add_foreign_key table_name, :ricer_servers, :column => :server_id,   :on_delete => :cascade
      m.add_foreign_key table_name, :arm_locales,   :column => :locale_id,   :on_delete => :nullify
      m.add_foreign_key table_name, :arm_encodings, :column => :encoding_id, :on_delete => :nullify
      m.add_foreign_key table_name, :arm_timezones, :column => :timezone_id, :on_delete => :nullify
    end
    
    
    #################
    ### Localized ###
    #################
    def locale; self.locale_id == nil ? server.locale : ActiveRecord::Magic::Locale.by_id(self.locale_id); end
    def timezone; self.timezone_id == nil ? server.timezone : ActiveRecord::Magic::Timezone.by_id(self.timezone_id); end
    def encoding; self.encoding_id == nil ? server.encoding : ActiveRecord::Magic::Encoding.by_id(self.encoding_id); end
    

    ###############
    ### Display ###
    ###############
    def obfuscated_name; no_highlight(self.name); end
    def display_name; "#{obfuscated_name}:#{server.domain}"; end

    ##############
    ### Helper ###
    ##############
    def server; Ricer4::Server.by_id(self.server_id); end
    
    #####################
    ### Communication ###
    #####################
    def wants_privmsg?; !self.wants_notice?; end
    def wants_notice?; self.message_type == 'n'; end

    ###########################
    ### Channel permissions ###
    ###########################
    # Get all permission objects
    def all_chanperms
      Ricer4::Chanperm.where(:user_id => self.id)
    end
    
    # Get permission object
    def chanperm_for(channel)
      cached_chanperm_for(channel) || load_chanperm_for(channel)
    end
    
    def cached_chanperm_for(channel)
      Ricer4::Chanperm.by_guid("#{self.id}:#{channel.id}")
    end

    def load_chanperm_for(channel)
      Ricer4::Chanperm.
        create_with(:permissions => self.permissions).
        find_or_create_by(:user_id => self.id, :channel_id => channel.id)
    end
    
    # Check for channel against other permission object 
    def has_channel_permission?(channel, permission, theoretically=false)
      perm = chanperm_for(channel)
      respect_auth = theoretically ? Permission.all_granted : perm.channel_permission
      perm.permission.has_permission?(permission, respect_auth)
    end
    
    ##########################
    ### Server permissions ###
    ##########################
    # Get permission object
    def permission
      Ricer4::Permission.by_permission(self.permissions, authenticated?)
    end
    
    # Check by permission object
    def has_permission?(permission, theoretically=false)
      respect_auth = theoretically ? Permission.all_granted : Permission::REGISTERED
      self.permission.has_permission?(permission, respect_auth)
    end

    ######################
    ### Authentication ###
    ######################
    def authenticate!(password)
      return @authenticated = false unless registered?
      password_matches?(password) ? login! : false 
    end

    def password_matches?(password)
      BCrypt::Password.new(self.hashed_password).is_password?(password)
    end

    def login!
      set_authed(true)
    end

    def logout!
      set_authed(false)
    end

    def set_authed(bool)
      if @authenticated != bool
        @authenticated = bool
        Ricer4::Chanperm.where(:user_id => self.id, :online => true).each do |chanperm|
          chanperm.authenticated = bool
        end
      end
      self
    end

    def authenticated?; @authenticated == true; end
    def registered?; !!self.hashed_password; end
    
    def password=(new_password)
      first_time = !self.registered?
      self.hashed_password = BCrypt::Password.create(new_password)
      self.save!
      register if first_time
    end
    
    private

    def register
      bits = Permission::REGISTERED.bit|Permission::AUTHENTICATED.bit
      self.permissions |= bits
      self.save!
      all_chanperms.each do |chanperm|
        chanperm.permissions |= bits
        chanperm.save!
      end
    end
    
  end
end