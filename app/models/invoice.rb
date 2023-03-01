class Invoice < ApplicationRecord
  belongs_to :company
  belongs_to :user
  belongs_to :customer

  has_one_attached :attachment

  def attachment_url
    ActiveStorage::Current.host = ENV['ROOT_PATH']
    attachment.present? ? attachment.service_url : nil
  end

  def attributes
  {
    'id' => id,
    "status": status,
    "amount": amount,
    "tax_percentage": tax_percentage,
    "discount_percentage": discount_percentage,
    "total_amount": total_amount,
    'created_at' => created_at,
    'user' => user,
    'customer' => customer,
    'attachment_url': attachment_url
  }
  end
end
