module Ricer4::Include::ChannelConnector
  
  def get_channel(server, channel_name)
    Ricer4::Channel.by_guid({ :name => channel_name, :server_id => server.id })
  end

  def load_channel(server, channel_name)
    if channel = get_channel(server, channel_name)
      if channel.offline?
        channel.set_online(true)
        arm_publish('ricer/channel/loaded', channel)
      end
    end
    channel
  end

  def load_or_create_channel(server, channel_name)
    unless channel = load_channel(server, channel_name)
      channel = Ricer4::Channel.create!({ :name => channel_name, :server_id => server.id, :online => true })
      arm_publish('ricer/channel/created', channel)
    end
    channel
  end
  
end
