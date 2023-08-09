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
end
