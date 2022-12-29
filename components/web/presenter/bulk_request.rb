class Web::Presenter::BulkRequest
  include Common::Helpers::TranslationHelper
  def initialize(dto:)
    @dto = dto
  end

  def present
    {
      id: @dto.id,
      user_id: @dto.user_id,
      external_ref_id: @dto.external_ref_id,
      long_url: @dto.long_url,
      bulkurl_ref_id: @dto.bulkurl_ref_id,
      webhook_url: @dto.webhook_url,
      status: @dto.status,
      email: @dto.email,
      csv_status:@dto.csv_status == 'completed' ? @dto.csv_status : 'in_progress',
      csv_link: @dto.csv_link,
      report:
        {
          status: @dto.report_status,
          report_link: @dto.report_link
        }
    }
  end

  def fetch_urls
    {
      campaign_id: @dto.external_ref_id,
      long_url: @dto.long_url,
      urls: @dto.urls
    }
  end

  def create_present
    {
      status: true,
      bulkurl_ref_id: @dto.bulkurl_ref_id
    }
  end

  def get_status
    {
      status: @dto.csv_status,
      link: @dto.csv_link
    }
  end
end
