module Ricer4::Plugins::Hash
  class Hash < Ricer4::Plugin
    
    trigger_is "hash.algo"
    
    has_usage '<string|named:"hash">'
    def execute(hash)
      
    end

    has_usage '<hash_algo> <message|named:"plaintext">', function: :execute_with_algo
    def execute_with_algo(algo, hash)
      
    end
    
  end
end