module ActiveRecord::Magic::Param
  class ChannelName < ActiveRecord::Magic::Param::String
    
    include Ricer4::Plugins::Irc::Lib

    def default_options; { min:1, max:200 }; end
    
    def validate!(channelname)
      super(channelname)
      invalid_channel_name! unless channelname_valid?(channelname)
    end
    
    def invalid_channel_name!
      invalid!(:err_channel_name_invalid)
    end
    
  end
end
