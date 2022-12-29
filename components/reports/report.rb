class Reports::Report < ApplicationRecord
  belongs_to :user, class_name: 'Users::User'
  belongs_to :bulk_request, class_name: 'BulkRequests::BulkRequest'

  enum status: {
    in_progress: 0,
    completed: 1,
    failed: 2
  }

  scope :by_account_id, -> (account_id) { includes(:user).references(:user).where('users.account_id = ?', account_id) }
  scope :by_status, -> (status) { where(status: status) }
end
