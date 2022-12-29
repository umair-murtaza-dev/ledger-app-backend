class Company < ApplicationRecord
  has_many :vendors, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :head_of_accounts, dependent: :destroy
  has_many :inventory_items, dependent: :destroy
  has_many :inventory_locations, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :store_locations, dependent: :destroy

end
