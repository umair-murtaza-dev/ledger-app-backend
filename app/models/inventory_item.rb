class InventoryItem < ApplicationRecord
  belongs_to :company
  has_many :inventory_locations
end
