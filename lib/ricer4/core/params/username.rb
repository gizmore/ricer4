module ActiveRecord::Magic
  class Param::Username < Param::String
    def default_options; {pattern: /[a-z]{1}[-a-z_0-9]{0,31}/}.reverse_merge(super); end
  end
end
    