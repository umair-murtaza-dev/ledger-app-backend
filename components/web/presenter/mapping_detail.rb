class Web::Presenter::MappingDetail
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      details: @dto.details
    }
  end
end
