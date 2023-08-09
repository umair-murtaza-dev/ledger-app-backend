class InventoryItem < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :company
  has_many :inventory_locations
end
