class Common::Translation
  def self.translate(value, locale=I18n.locale)
    case locale.to_s
    when 'ar'
      value.to_s.tr('0123456789', '٠١٢٣٤٥٦٧٨٩')
    else
      value
    end
  end
end
