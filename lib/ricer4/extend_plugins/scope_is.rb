module Ricer4::Extend::ScopeIs
  def scope_is(scope=:everywhere)
    class_eval do |klass|
      
      klass.define_class_variable(:@default_scope, scope)

    end
  end
end
