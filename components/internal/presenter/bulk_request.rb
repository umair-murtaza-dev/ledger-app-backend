class Internal::Presenter::BulkRequest
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
      email: @dto.email,
      status: @dto.status,
      csv_status: @dto.csv_status == 'completed' ? @dto.csv_status : 'In-progress',
      csv_link: @dto.csv_status == 'completed' ? @dto.csv_link : 'CSV file creation in progress'
    }
  end

  def ref_id_present(url_mapping:)
    {
      campaign_id: @dto.external_ref_id,
      long_url: @dto.long_url
    }.merge(url_mapping.present? ? mapping_details(url_mapping) : {})
  end

  def mapping_details(url_mapping)
    {
    reference_id: url_mapping[:reference_id],
      tags: url_mapping[:tags],
      short_url: url_mapping[:short_url],
      id: url_mapping[:id],
      clicks: url_mapping[:clicks],
      location: "USA"
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
      bulkurl_ref_id: @dto.bulkurl_ref_id || "reference-internal-uuid",
      trace_id: @dto.trace_id
    }
  end

  def get_status
    {
       status: @dto.csv_status,
       link: @dto.csv_link
     }
  end
end
