class Company < ApplicationRecord
  acts_as_paranoid

  has_many :vendors, dependent: :destroy
  has_many :expenses, dependent: :destroy
  has_many :head_of_accounts, dependent: :destroy
  has_many :inventory_items, dependent: :destroy
  has_many :inventory_items_locations, :through => :inventory_items, :source => 'inventory_locations'

  has_many :inventory_locations, dependent: :destroy
  has_many :projects, dependent: :destroy
  has_many :store_locations, dependent: :destroy
  has_many :invoices
  has_many :customers
  has_many :users
  has_many :accounts

  has_one_attached :logo
end
