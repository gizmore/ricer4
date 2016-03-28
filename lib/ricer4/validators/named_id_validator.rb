class NamedIdValidator < ActiveModel::EachValidator

  I18N_ERR = 'active_record.validators.named_id_validator.err'
  I18N_ERR_TXT = 'is an invalid NamedID'
  
  def default_options
    { min: 1, max: 48 }
  end

  def validate_each(record, attribute, value)
    @options = default_options.merge(self.options)
    unless value =~ Regexp.new("^[a-zA-Z][a-zA-Z0-9_]{#{min-1},#{max-1}}$", true)
      record.errors[attribute] << message
    end
  end

  private
  
  def min
    @options[:min]
  end

  def max
    @options[:max]
  end
  
  def message
    @options[:message] || default_message
  end
  
  def default_message
    I18n.exists?(I18N_ERR) ? I18n.t(I18N_ERR) : I18N_ERR_TXT
  end
    
end
