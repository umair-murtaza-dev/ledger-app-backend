class Invoice < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  belongs_to :user
  belongs_to :customer

  has_one :attachment

  def attachment_url
    invoice_attachment = Attachment.find_by(attachment_for: self)
    return nil unless invoice_attachment.present?

    ActiveStorage::Current.host = ENV['ROOT_PATH']
    invoice_attachment.attachment.present? ? invoice_attachment.attachment.service_url : nil
  end

  enum status: {
    active: 1,
    paid: 2,
    non_paid: 3
  }, _prefix: true

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

  def self.apply_filter(query)
    invoices = where(status: "#{query}") if statuses.keys.include?("#{query}")
    invoices = joins(:customer).where("customers.firstname ILIKE :term OR customers.lastname ILIKE :term", term: "%#{query}%") unless invoices.present?
    invoices
  end
end
