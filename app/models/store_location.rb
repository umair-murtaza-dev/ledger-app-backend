class StoreLocation < ApplicationRecord
  belongs_to :company
  has_many :inventory_locations
end
