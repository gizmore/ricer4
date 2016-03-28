module Ricer4::Plugins::Hash
  class Crack < Ricer4::Plugin
    
    trigger_is "hash.crack"
    
    has_usage '<string|named:"hash">'
    def execute(hash)
      
    end

    has_usage '<hash_algo> <string|named:"hash">', function: :execute_with_algo
    def execute_with_algo(algo, hash)
      
    end
    
  end
end