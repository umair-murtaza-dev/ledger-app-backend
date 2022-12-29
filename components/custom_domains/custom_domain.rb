class CustomDomains::CustomDomain < ApplicationRecord
  belongs_to :user, class_name: 'Users::User'
  has_many :url_mappings, class_name: 'UrlMappings::UrlMapping', dependent: :destroy

  validates_uniqueness_of :point_to
  validates :host, uniqueness: { scope: :point_to }
  validates :ssl_certificate, :point_to, :host, presence: true

  enum status: {
    un_verified: 0,
    verified: 1,
    failed: 2
  }

  scope :by_account_id, -> (account_id) { includes(:user).references(:user).where('users.account_id = ?', account_id) }
  scope :by_id, -> (id) { where(id: id) }
  scope :by_name, -> (name) { where(name: name) }
  scope :by_host, -> (host) { where(host: host) }
  scope :by_point_to, -> (by_point_to) { where(by_point_to: by_point_to) }
  scope :by_status, -> (status) { where(status: status) }
end
