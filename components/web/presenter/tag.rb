class Web::Presenter::Tag
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      title: @dto.title
    }
  end

  def tiny_url_presenter
    "#{@dto.host_url}#{@dto.redirect_key}"
  end
end
