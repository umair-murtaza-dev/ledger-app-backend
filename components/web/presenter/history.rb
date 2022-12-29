class Web::Presenter::History
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      title: @dto.title,
      redirect_key: @dto.service_id,
      host_url: @dto.host_url,
      redirect_key: @dto.redirect_key,
      redirect_link: "#{@dto.host_url}#{@dto.redirect_key}",
      allowed_hits: @dto.allowed_hits,
      remaining_hits: @dto.remaining_hits
    }
  end

  def redirect_link_presenter
    "#{@dto.host_url}#{@dto.redirect_key}"
  end
end
