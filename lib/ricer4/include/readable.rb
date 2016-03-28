require 'action_view'
require 'active_support'
module Ricer4::Include::Readable

#  include ActionView::Helpers
  include ActionView::Helpers::NumberHelper
  include ActionView::Helpers::SanitizeHelper

  ACTION ||= "\x01"; def action_text(text); "\x01#{text}\x01"; end
  BOLD   ||= "\x02"; def bold_text(text);   "\x02#{text}\x02"; end
  ITALIC ||= "\x03"; def italic_text(text); "\x03#{text}\x03"; end

  #############
  ### Units ###
  #############
  def human_filesize(bytes)
    number_to_human_size(bytes)
  end
  
  def human_fraction(fraction, precision=1)
    number_with_precision(fraction, precision: precision)
  end
  
  def human_percent(fraction, precision=2)
    human_fraction(fraction*100, precision)+'%'
  end
  
  ################
  ### Duration ###
  ################
  def human_age(datetime)
    human_duration_between(datetime, Time.now)
  end

  def human_duration_between(a, b)
    human_duration((a.to_f - b.to_f).abs)
  end
  
  def human_duration(seconds, options={})
    ChronicDuration.output(seconds, chronic_options.merge(options))
  end
  
  def human_to_seconds(human, options={})
    ChronicDuration.parse(human, chronic_options.merge(options))
  end
  
  def chronic_options
    { format: :micro, units: 2 }
  end

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
  def und; I18n.t!('ricer3.and') rescue ' and '; end
  def comma; I18n.t!('ricer3.comma') rescue ', '; end
  def human_join(array); array.count < 2 ? (array[0].to_s) : (join(array[0..-2]) + und + array[-1].to_s); end

  ############
  ### HTML ###
  ############
  def strip_html(html)
    ActionView::Base.full_sanitizer.sanitize(html)
  end
    
end
