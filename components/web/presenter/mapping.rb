class Web::Presenter::Mapping
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
      redirect_link: @dto.redirect_link,
      uuid: @dto.uuid,
      tiny_url: tiny_url_presenter,
      allowed_hits: @dto.allowed_hits,
      remaining_hits: @dto.remaining_hits,
      clicks: @dto.clicks,
      tags: @dto.tags,
      variable: @dto.redirect_key,
      location: @dto.location,
      tags: @dto.mapping_tags,
      custom_domain: @dto.custom_domain
    }
  end

  def tiny_url_presenter
    "#{@dto.host_url}#{@dto.redirect_key}"
  end
end
