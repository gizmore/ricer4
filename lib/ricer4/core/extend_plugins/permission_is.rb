module Ricer4::Extend::PermissionIs
  def permission_is(permission=:public)
    class_eval do |klass|
      
      throw Exception.new("#{klass} permission_is invalid: #{permission}") unless Ricer4::Permission.by_name(permission)
      
      klass.define_class_variable(:@default_permission, permission)
      
    end
  end
end
