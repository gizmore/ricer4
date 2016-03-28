module Ricer4::Plugins::Conf
  class ConfUser < ConfBase

    trigger_is :confu
    always_enabled

    has_usage  '<plugin> <variable> <value>', function: :set_var
    has_usage  '<plugin> <variable>', function: :show_var
    has_usage  '<plugin>', function: :show_vars

    def config_scope; [:user]; end
    def config_object; sender; end 

  end
end
