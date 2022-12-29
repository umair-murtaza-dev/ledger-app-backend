class UrlMappings::UrlMapping < ApplicationRecord
  # attribute :uuid, MySQLBinUUID::Type.new

  has_many :histories, class_name: 'Histories::History', dependent: :destroy
  # has_many :url_mapping_tags, class_name: "UrlMappings::UrlMappingTag",  dependent: :destroy
  # has_many :tags, through: :url_mapping_tags, class_name: "Tags::Tag"

  belongs_to :user, class_name: 'Users::User'
  belongs_to :bulk_request, class_name: 'BulkRequests::BulkRequest', optional: true
  belongs_to :custom_domain, class_name: 'CustomDomains::CustomDomain', optional: true

  validates_uniqueness_of :redirect_key
  validates :external_ref_id, uniqueness: true, :allow_blank => true , if: Proc.new { |url| url.bulk_request_id.blank? }
  validates :redirect_key, :host_url, presence: true
  validate :clean_title
  validate :clean_redirect_key
  validate :redirect_link_has_correct_format

  scope :by_user_id, -> (user_id) { where(user_id: user_id)  }
  scope :without_bulk_request, -> { where(bulk_request_id: nil) }
  scope :by_id, -> (id) { where(id: id) }
  scope :by_uuid, -> (uuid) { where(uuid: uuid) }
  scope :by_title, -> (title) { where(title: title) }
  scope :by_redirect_key, -> (redirect_key) { where(redirect_key: redirect_key) }
  scope :by_external_ref_id, -> (external_ref_id) { where(external_ref_id: external_ref_id) }
  scope :by_bulkrequest_external_ref_id, -> (external_ref_id) { joins(:bulk_request).where('bulk_requests.external_ref_id = ?', external_ref_id) }
  scope :by_bulkurl_ref_id, -> (bulkurl_ref_id) { joins(:bulk_request).where('bulk_requests.bulkurl_ref_id = ?', bulkurl_ref_id) }
  scope :by_trace_id, -> (trace_id) { where(trace_id: trace_id) }

  def clean_title
    profanity_filter = LanguageFilter::Filter.new matchlist: :profanity
    if profanity_filter.match? title then
      errors.add(:title, "The following language is inappropriate in title: #{profanity_filter.matched(title).join(', ')}")
    end

    hate_filter = LanguageFilter::Filter.new matchlist: :hate
    if hate_filter.match? title then
      errors.add(:title, "The following language is inappropriate in title: #{hate_filter.matched(title).join(', ')}")
    end

    sex_filter = LanguageFilter::Filter.new matchlist: :sex
    if sex_filter.match? title then
      errors.add(:title, "The following language is inappropriate in title: #{sex_filter.matched(title).join(', ')}")
    end

    violence_filter = LanguageFilter::Filter.new matchlist: :violence
    if violence_filter.match? title then
      errors.add(:title, "The following language is inappropriate in title: #{violence_filter.matched(title).join(', ')}")
    end
  end


  def clean_redirect_key
    profanity_filter = LanguageFilter::Filter.new matchlist: :profanity
    if profanity_filter.match? redirect_key then
      errors.add(:redirect_key, "The following language is inappropriate in redirect_key: #{profanity_filter.matched(redirect_key).join(', ')}")
    end

    hate_filter = LanguageFilter::Filter.new matchlist: :hate
    if hate_filter.match? redirect_key then
      errors.add(:redirect_key, "The following language is inappropriate in redirect_key: #{hate_filter.matched(redirect_key).join(', ')}")
    end

    sex_filter = LanguageFilter::Filter.new matchlist: :sex
    if sex_filter.match? redirect_key then
      errors.add(:redirect_key, "The following language is inappropriate in redirect_key: #{sex_filter.matched(redirect_key).join(', ')}")
    end

    violence_filter = LanguageFilter::Filter.new matchlist: :violence
    if violence_filter.match? redirect_key then
      errors.add(:redirect_key, "The following language is inappropriate in redirect_key: #{violence_filter.matched(redirect_key).join(', ')}")
    end
  end

  def redirect_link_has_correct_format
    errors.add(:redirect_link, "Wrong Long URL") unless redirect_link.downcase.start_with?('https://', 'http://')
  end

  # def check_flow_studio_request
  #   KafkaWebhook::Service.new.push_flow_studio_event(url_mapping_id: self.id)  if external_ref_id&.start_with?('FLOWSTUDIO:ledger:')
  # end
end
