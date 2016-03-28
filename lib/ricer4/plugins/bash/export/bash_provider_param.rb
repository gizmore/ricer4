class ActiveRecord::Magic::Param::BashProvider < ActiveRecord::Magic::Param::Enum
  
  def self.bash_providers
    [:bash_org, :german_bash_org]
  end
  
  def default_options
    super.merge({ enums: self.class.bash_providers, default: self.class.bash_providers[1], multiple: false })
  end
  
  def input_to_value(input)
    puts "INPUT: #{input}"
    Ricer4::Plugins::Bash::Provider.by_name(input)
  end
  
  def value_to_input(provider)
    provider.name
  end
  
  def validate!(provider)
    invalid!(:err_unknown_provider) unless provider.is_a?(Ricer4::Plugins::Bash::Provider)
  end
  
end