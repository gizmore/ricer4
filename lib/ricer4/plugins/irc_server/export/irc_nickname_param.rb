class ActiveRecord::Magic::Param::IrcNickname < ActiveRecord::Magic::Param::String

  include Ricer4::Plugins::Irc::Lib
  
  def default_options; { min:1, max:128 }; end
    
  def validate!(nickname)
    super(nickname)
    invalid_nickname! unless nickname_valid?(nickname)
  end
    
  def invalid_nickname!
    invalid!(:err_nickname_invalid)
  end

end
