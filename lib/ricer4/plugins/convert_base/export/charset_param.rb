class ActiveRecord::Magic::Param::Charset < ActiveRecord::Magic::Param::String
  
  BASE64 ||= '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ+-'
  
  def default_options; { min: 2, max: 64, default: nil, null: true }; end

end