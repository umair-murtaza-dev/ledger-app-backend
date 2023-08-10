class InventoryLocation < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  belongs_to :inventory_item
  belongs_to :store_location

  def self.apply_filter(query)
    inventory_locations = where(quantity: query)
    inventory_locations
  end
end
