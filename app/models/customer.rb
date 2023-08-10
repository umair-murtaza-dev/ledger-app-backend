class Customer < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  has_many :invoices

  def attributes
  {
    'id' => self.id,
    'firstname' => firstname,
    'lastname' => lastname,
    'currency' => currency,
    'phone' => phone,
    'address' => address,
    'created_at' => created_at,
    'company' => company
  }
  end

  def self.apply_filter(query)
    customers = where("lower(customers.firstname) LIKE :term OR lower(customers.lastname) LIKE :term OR lower(customers.address) LIKE :term OR lower(customers.phone) LIKE :term", term: "%#{query.downcase}%")
    customers
  end
end
