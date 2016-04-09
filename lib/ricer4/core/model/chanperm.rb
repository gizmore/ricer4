class Ricer4::Chanperm < ActiveRecord::Base

    include Ricer4::Include::OnlineRecord
    
    self.table_name = "ricer_chanperms"

    #############
    ### Cache ###
    #############
    arm_cache
    arm_named_cache :guid, Proc.new { |values| "#{values[:user_id]}:#{values[:channel_id]}" }

    ################
    ### Database ###
    ################
    arm_install() do |m|
      m.create_table table_name do |t|
        t.integer  :user_id,       :null => false, :unsigned => true
        t.integer  :channel_id,    :null => false, :unsigned => true
        t.integer  :permissions,   :null => false, :unsigned => true
        t.boolean  :online,        :null => false, :default => true
      end
    end
    
    arm_install("Ricer4::User" => 1, "Ricer4::Server" => 1) do |m|
      m.add_foreign_key table_name, :users,    :on_delete => :cascade rescue nil
      m.add_foreign_key table_name, :channels, :on_delete => :cascade rescue nil
    end

    def user
      @user ||= Ricer3::User.by_id(self.user_id)
    end

    def channel
      @channel ||= Ricer3::Channel.by_id(self.channel_id)
    end
    
    def chanmode
      @chanmode ||= Ricer3::ChannelMode.new(Ricer3::Permission::PUBLIC)
    end
    
    def user_permission
      user.permission
    end
    
    def channel_permission
      chanmode.permission
    end
    
    # def ricer_permission
      # Ricer3::Permission.by_permission(self.permissions, authenticated?)
    # end
    
    def authenticated?
      user.authenticated?
    end
    
    def authenticated=(boolean)
      chanmode.permission.authenticated = boolean
    end
    
    def permission_bits
      self.permissions | user.permissions | chanmode.permission.bit      
    end
    
    def permission
      Ricer3::Permission.by_permission(permission_bits, authenticated?)
    end
    
end