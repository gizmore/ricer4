module Ricer4::Include::ChecksPermission
  
  def get_permission
    Ricer4::Permission::PUBLIC
  end
  
  def get_scope
    Ricer4::Scope::BOTH
  end
  
  def has_scope?
    get_scope.in_scope?(current_message.scope)
  end

  def has_scope_and_permission?(theoretically=false)
    has_scope? && has_permission?(theoretically)
  end

  def has_permission?(theoretically=false)
    has_user_permission?(sender, theoretically)
  end
  
  def has_user_permission?(user, theoretically=false)
    channel ?
      has_user_channel_permission?(user, channel, theoretically) :
      user.has_permission?(get_permission, theoretically)
  end
  
  def has_user_channel_permission?(user, channel, theoretically=false)
    user.has_channel_permission?(channel, get_permission, theoretically)
  end

  def has_channel_permission?(channel, theoretically=false)
    has_user_channel_permission?(sender, channel, theoretically)
  end

end
