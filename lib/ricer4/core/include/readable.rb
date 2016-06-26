require 'htmlentities'

module Ricer4::Include::Readable

  ACTION ||= "\x01"; def action_text(text); "\x01#{text}\x01"; end
  BOLD   ||= "\x02"; def bold_text(text);   "\x02#{text}\x02"; end
  ITALIC ||= "\x03"; def italic_text(text); "\x03#{text}\x03"; end

  ############
  ### Date ###
  ############
  def gdo_date(time)
    time.strftime('%Y%m%d%H%M%S')
  end
  
  def ruby_date(gdo_date)
    d = gdo_date
    DateTime.new(d[0..3].to_i, d[4..5].to_i, d[6..7].to_i, d[8..9].to_i, d[10..11].to_i, d[12..13].to_i)
  end
  
  ############
  ### Join ###
  ############    
  def join(array); array.join(comma); end
  def und; I18n.t!('ricer4.and') rescue ' and '; end
  def comma; I18n.t!('ricer4.comma') rescue ', '; end
  def human_join(array); array.count < 2 ? (array[0].to_s) : (join(array[0..-2]) + und + array[-1].to_s); end
  def shorten(s, maxlen=nil, char='…')
    maxlen ||= 128;
    return char if s.length <= 1
    s.length >= maxlen ? 
      (s[0...maxlen] + char) :
      (s);
  end

  def no_html(s, maxlen=nil)
   shorten(s, maxlen)
  end
  
  def html_decode(s)
    HTMLEntities.new.decode(s)
  end
  
  def printjson(obj)
    obj.to_s
  end

end
