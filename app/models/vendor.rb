class Vendor < ApplicationRecord
  acts_as_paranoid

  belongs_to :company
  has_many :expenses

  def attributes
  {
    'id' => self.id,
    'title' => title,
    'code' => code,
    'address' => address
  }
  end
end
