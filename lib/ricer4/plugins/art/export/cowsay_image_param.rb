class ActiveRecord::Magic::Param::CowsayImage < ActiveRecord::Magic::Param::Enum
  
  def default_options; { enums: cowsay_symbols, default: :default }; end
  
  def cowsay_symbols
    [:default]
  end
  
end