class InventoryLocation < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :company
  belongs_to :inventory_item
  belongs_to :store_location
end
