class ActiveRecord::Magic::Param::NumericBase < ActiveRecord::Magic::Param::Integer
  
  def default_options; { min: 2, max: 64 }; end

end
