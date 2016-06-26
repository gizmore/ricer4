class Ricer4::Hash
  
  LENGTH ||= 128
  
  def self.sum(s)
    Digest::MD5.hexdigest(s)
  end
  
end
