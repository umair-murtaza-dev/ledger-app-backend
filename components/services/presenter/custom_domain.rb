class Services::Presenter::CustomDomain
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      uuid: @dto.uuid,
      user_id: @dto.user_id,
      account_id: @dto.account_id,
      name: @dto.name,
      host: @dto.host,
      point_to: @dto.point_to,
      status: @dto.status,
      custom_domain: @dto.custom_domain
    }
  end
end
