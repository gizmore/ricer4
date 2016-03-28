module Ricer4::Plugins::Conf
  class Conf < ConfBase
  
    trigger_is :conf

    has_usage  '<plugin> <variable> <value>', function: :set_var
    has_usage  '<plugin> <variable>', function: :show_var
    has_usage  '<plugin>', function: :show_vars

    def config_scope; Ricer4::Plug::Setting::SCOPES; end

  end
end
