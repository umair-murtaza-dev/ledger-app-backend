class Web::Presenter::User
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      account_id: @dto.account_id,
      auth_token: @dto.enabled ? @dto.auth_token : nil,
      enabled: @dto.enabled,
      api_link: @dto.api_link
    }
  end
end
