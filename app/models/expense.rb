class Expense < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  belongs_to :vendor
  belongs_to :head_of_account
  belongs_to :user

  has_one :attachment

  def attachment_url
    invoice_attachment = Attachment.find_by(attachment_for: self)
    return nil unless invoice_attachment.present?

    ActiveStorage::Current.host = ENV['ROOT_PATH']
    invoice_attachment.attachment.present? ? invoice_attachment.attachment.service_url : nil
  end

  def attributes
  {
    'id' => id,
    'title' => title,
    'amount' => amount,
    'description' => description,
    'sales_tax' => sales_tax,
    'witholding_tax' => witholding_tax,
    'created_at' => created_at,
    'vendor' => vendor.attributes,
    'head_of_account' => head_of_account,
    'user' => user,
    'attachment_url': attachment_url
  }
  end

  def self.apply_filter(query)
    expenses = where("lower(expenses.title) LIKE :term", term: "%#{query.downcase}%")
    expenses = joins(:head_of_account).where("head_of_accounts.code ILIKE :term OR head_of_accounts.title ILIKE :term", term: "%#{query}%") unless expenses.present?
    expenses
  end
end
