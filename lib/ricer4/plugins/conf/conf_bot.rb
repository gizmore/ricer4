load File.expand_path("../conf_base.rb", __FILE__)
module Ricer4::Plugins::Conf
  class ConfBot < ConfBase
    
    trigger_is :confb
    always_enabled

    has_usage  '<plugin> <variable> <value>', function: :set_var
    has_usage  '<plugin> <variable>', function: :show_var
    has_usage  '<plugin>', function: :show_vars

    def config_scope; [:bot]; end
    def config_object; bot; end 
    
  end
end
