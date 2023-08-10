class StoreLocation < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  has_many :inventory_locations

  def self.apply_filter(query)
    store_locations = where("lower(store_locations.code) LIKE :term", term: "%#{query.downcase}%")
    store_locations
  end
end
