class Users::User < ApplicationRecord

  has_many :url_mappings, class_name: 'UrlMappings::UrlMapping', dependent: :destroy
  has_many :bulk_requests, class_name: 'BulkRequests::BulkRequest', dependent: :destroy
  has_many :reports, class_name: 'Reports::Report', dependent: :destroy

  validates :account_id, uniqueness: true
  validates :account_id, presence: true

  scope :by_account_id, -> (account_id) { where(account_id: account_id) }
  scope :by_id, -> (id) { where(id: id) }

end
