module Ricer4::Include::UserConnector
  
  def user_attributes(server, user_name)
    { :name => user_name, :server_id => server.id }
  end
  
  def get_user(server, user_name)
    user = Ricer4::User.by_guid({name: user_name, server_id: server.id})
    return user if user
    user = Ricer4::User.where(user_attributes(server, user_name)).first
    if user
      user.set_online(true)
      arm_publish('ricer/user/loaded', user)
    end
    user
  end
  
  def create_user(server, user_name)
    user = Ricer4::User.create!(user_attributes(server, user_name))
    arm_publish('ricer/user/created', user)
    user.set_online(true)
    user
  end
  
  def load_or_create_user(server, user_name)
    get_user(server, user_name) || 
    create_user(server, user_name)
  end
  
  def user_quit_server(server, user)
    user.set_online(false)
    arm_publish('ricer/user/quit', user)
  end
  
end
