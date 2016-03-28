class ActiveRecord::Magic::Param::Page < ActiveRecord::Magic::Param::Integer
  
  def default_options; { min: 1, default: 1 }.reverse_merge(super); end
  
end