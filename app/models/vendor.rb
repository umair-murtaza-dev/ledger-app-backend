class Vendor < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  has_many :expenses

  def attributes
  {
    'id' => self.id,
    'title' => title,
    'code' => code,
    'address' => address
  }
  end

  def self.apply_filter(query)
    vendors = where("lower(vendors.code) LIKE :term OR lower(vendors.title) LIKE :term OR lower(vendors.address) LIKE :term", term: "%#{query.downcase}%")
    vendors
  end
end
