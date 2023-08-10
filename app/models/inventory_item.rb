class InventoryItem < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  has_many :inventory_locations

  def self.apply_filter(query)
    inventory_items = where("lower(inventory_items.code) LIKE :term OR lower(inventory_items.title) LIKE :term", term: "%#{query.downcase}%")
    inventory_items
  end
end
