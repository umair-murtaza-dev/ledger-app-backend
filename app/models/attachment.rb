class Attachment < ApplicationRecord
  belongs_to :company
  belongs_to :attachment_for, polymorphic: true

  has_one_attached :attachment

  def attachment_url
    ActiveStorage::Current.host = ENV['ROOT_PATH']
    attachment.present? ? attachment.service_url : nil
  end

  def attributes
  {
    'id' => id,
    'attachment_for_type' => attachment_for_type,
    "attachment_for_id": attachment_for_id,
    'company' => company,
    'attachment_url': attachment_url
  }
  end

  def self.validates_attachment(attachment)
    return "file not attached" unless attachment.present?
    return "size needs to be less than 5MB" if attachment.size > 5.megabytes
    return "file format invalid" unless ['image/jpeg', 'image/jpg', 'image/png'].include?(attachment.content_type)
    true
  end
end
