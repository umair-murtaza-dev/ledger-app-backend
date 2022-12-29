class Sso::Presenter::Currency
  def initialize(dto:)
    @currency = dto
  end

  def present
    {
      "id": @currency.id,
      "key": @currency.key,
      "name": @currency.name,
      "code": @currency.code
    }
  end
end
