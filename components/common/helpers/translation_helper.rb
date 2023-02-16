module Common::Helpers::TranslationHelper
  def include_translations(obj, keys, voice=false, attachment=false)
    result = {}
    Array(keys).each do |key|
      result[key.to_sym] = obj.send(key)
      locales(voice).each do |locale|
        attribute = "#{key}_#{locale.key}"
        value = obj.send(attribute)
        if attachment
          if value.present?
            value = value.url
            value = 'https:'+value unless value.starts_with?('http')
          else
            value = nil
          end
        end
        result[attribute.to_sym] = value
      end
    end
    result
  end

  def presenter_translation(obj, keys, voice=false)
    result = {}
    Array(keys).each do |key|
      result[key] ||= {}
      locales(voice).each do |locale|
        attribute = "#{key}_#{locale.key}"
        result[key][locale.key] = obj.send(attribute)
      end
    end
    result
  end

  def permit_translation(keys, voice=false)
    result = []
    Array(keys).each do |key|
      locales(voice).each do |locale|
        result << "#{key}_#{locale.key}".to_sym
      end
    end
    result
  end

  def locales(voice=false)
    voice ? Locales::Locale.all_voice_enabled : Locales::Locale.all
  end
end
