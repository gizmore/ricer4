class ActiveRecord::Magic::Param::ServerUrl < ActiveRecord::Magic::Param::Url
  
  def default_options; super.merge({ schemes: [:irc, :ircs] }); end
  
end