class BulkRequests::BulkRequest < ApplicationRecord
  belongs_to :user, class_name: 'Users::User'
  belongs_to :custom_domain, class_name: 'CustomDomains::CustomDomain', optional: true
  has_many :url_mappings, class_name: 'UrlMappings::UrlMapping', dependent: :destroy
  has_many :reports, class_name: 'Reports::Report', dependent: :destroy

  has_one_attached :file

  validates_uniqueness_of :external_ref_id, :bulkurl_ref_id, on: :create, scope: :user_id
  validates :external_ref_id, :bulkurl_ref_id, :file, presence: true
  validate :redirect_link_has_correct_format

  enum status: {
    pending: 0,
    in_progress: 1,
    complete: 2,
    fail: 3
  }

  enum csv_status: {
    processing: 1,
    completed: 2,
    failed: 3
  }

  enum source: {
    tiny_url: 0,
  }

  scope :by_account_id, -> (account_id) { includes(:user).references(:user).where('users.account_id = ?', account_id) }
  scope :by_id, -> (id) { where(id: id) }
  scope :by_external_ref_id, -> (external_ref_id) { where(external_ref_id: external_ref_id) }
  scope :by_long_url, -> (long_url) { where(long_url: long_url) }
  scope :by_bulkurl_ref_id, -> (bulkurl_ref_id) { where(bulkurl_ref_id: bulkurl_ref_id) }
  scope :by_email, -> (email) { where(email: email) }
  scope :by_status, -> (status) { where(status: status) }
  scope :by_csv_status, -> (csv_status) { where(csv_status: csv_status) }
  scope :by_source, -> (source) { where(source: source) }
  scope :by_trace_id, -> (trace_id) { where(trace_id: trace_id) }

  def redirect_link_has_correct_format
    return if long_url.blank?
    errors.add(:long_url, "must start with https or http") unless long_url.downcase.start_with?('https://', 'http://')
  end
end
