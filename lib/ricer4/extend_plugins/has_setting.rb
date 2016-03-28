###
### Provides has_setting extender for plugins.
### Settings can have a scope and a permission who may alter it with "!config".
### Values can be conviniently get, set and shown.
###
### Example:
### has_setting name: :bugs_per_file, type: :integer, scope: :server, permission: :admin, min: -2, max: 100, default: 5 
###
module Ricer4::Extend::HasSetting
  def has_setting(options)
    class_eval do |klass|
      
      klass.arm_settings
      klass.arm_setting(options)
      
    end
  end
end
