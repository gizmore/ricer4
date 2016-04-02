module Ricer4::Extend::ExecuteChains
  
  def register_exec_function(function)
    functions = define_class_variable(:@exec_functions, [])
    functions.push(function.to_sym) unless functions.include?(function.to_sym)
    functions
  end
  
end
