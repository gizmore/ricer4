module Ricer4::Include::UserConnector
  
  def get_user(server, user_name)
    Ricer4::User.by_guid({name: user_name, server_id: server.id})
  end
  
  def load_or_create_user(server, user_name)
    load_user(server, user_name) || create_user(server, user_name)
  end
  
  def load_user(server, user_name)
    if user = get_user(server, user_name)
      user_joined_server(user)
    end
    user
  end
  
  def create_user(server, user_name)
    user = Ricer4::User.create!({ :name => user_name, :server_id => server.id, :online => true })
    arm_publish('ricer/user/created', user)
    user
  end
  
  def user_joined_server(user)
    if user.set_online
      arm_publish('ricer/user/loaded', user)
    end
  end
  
  def user_quit_server(user)
    if user.set_offline
      arm_publish('ricer/user/quit', user)
    end
  end
  
end
