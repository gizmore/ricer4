class ActiveRecord::Magic::Param::Phone < Ricer4::Parameter
  
  def input_to_value(input)
    input.gsub(/[^+0-9]/, '')
  end

  def value_to_input(number)
    number.to_s
  end
  
  def validate!(number)
    invalid!(:err_start_country) unless number.start_with?('+')
    invalid!(:err_format) unless /\+[1-9][0-9]+/.match(number)
  end
  
end