module ActiveRecord::Magic
  class Param::Port < Param::Integer
   
   def default_options; super.merge({ min: 1, max: 65535 }); end

  end
end
