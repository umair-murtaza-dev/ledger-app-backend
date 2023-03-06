class Expense < ApplicationRecord
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
end
