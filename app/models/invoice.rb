class Invoice < ApplicationRecord
  belongs_to :company
  belongs_to :user

  has_one_attached :attachment

  def attachment_url
    # ActiveStorage::Current.host = "http://localhost:3000" #uncomment to fix dev error
    attachment.present? ? attachment.service_url : nil
  end

  def attributes
  {
    'id' => id,
    "from_name": from_name,
    "from_address": from_address,
    "from_phone": from_phone,
    "to_name": to_name,
    "to_address": to_address,
    "to_phone": to_phone,
    "status": status,
    "currency": currency,
    "amount": amount,
    "tax_percentage": tax_percentage,
    "discount_percentage": discount_percentage,
    "total_amount": total_amount,
    'created_at' => created_at,
    'user' => user,
    'attachment_url': attachment_url
  }
  end
end
