class Web::Presenter::BulkRequestReport
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      user_id: @dto.user_id,
      bulk_request_id: @dto.bulk_request_id,
      status: @dto.status,
      report_link: @dto.report_link
    }
  end
end
