class CentsValidator < ActiveModel::EachValidator

  # Check cents being 0 to 2 digits
  def validate_each(record, attribute, value)
    if !value.nil? && value.to_s.split('.')[1].length > 2
      record.errors[attribute] << (options[:message] ||
        "#{attribute} cannot use fractions of cents (2 digits only)")
    end
  end

end
