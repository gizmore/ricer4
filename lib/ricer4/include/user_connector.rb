module Ricer4::Include::UserConnector
  
  def user_attributes(server, user_name)
    { :name => user_name, :server_id => server.id }
  end
  
  def get_user(server, user_name)
    user = Ricer3::User.global_cache["#{user_name.downcase}:#{server.id}"] 
    return user if user
    user = Ricer3::User.where(user_attributes(server, user_name)).first
    if user
      user.set_online(true)
      broadcast('ricer/user/loaded', user)
    end
    user
  end
  
  def create_user(server, user_name)
    user = Ricer3::User.create!(user_attributes(server, user_name))
    broadcast('ricer/user/created', user)
    user.set_online(true)
    user
  end
  
  def load_or_create_user(server, user_name)
    get_user(server, user_name) || 
    create_user(server, user_name)
  end
  
  def user_quit_server(server, user)
    user.set_online(false)
    broadcast('ricer/user/quit', user)
  end
  
end
