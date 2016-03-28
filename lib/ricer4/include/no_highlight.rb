#####################
###   A N  T I    ###
### high-lighting ###
### (thx noother) ###
#####################
module Ricer4::Include::NoHighlight

    def no_highlight(string)
      obfuscate(string)||softhype(string)
    end

    def obfuscate(string)
      [
        "A\xce\x91", "B\xce\x92", "C\xd0\xa1", "E\xce\x95", "F\xcf\x9c",
        "H\xce\x97", "I\xce\x99", "J\xd0\x88", "K\xce\x9a", "M\xce\x9c",
        "N\xce\x9d", "O\xce\x9f", "P\xce\xa1", "S\xd0\x85", "T\xce\xa4",
        "X\xce\xa7", "Y\xce\xa5", "Z\xce\x96",
        "a\xd0\xb0", "c\xd1\x81", "e\xd0\xb5", "i\xd1\x96", "j\xd1\x98",
        "o\xd0\xbe", "p\xd1\x80", "s\xd1\x95", "x\xd1\x85", "y\xd1\x83",
      ].each do |r|
        return string.sub(r[0], r[1..-1]) unless string.index(r[0]).nil?
      end
      nil
    end

    def softhype(string)
      return string if string.length < 2
      i = bot.rand.rand(1..string.length-1)
      string[0..i] + "\xC2\xAD" + string[i..-1]
    end
  
end
