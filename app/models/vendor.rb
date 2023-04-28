class Vendor < ApplicationRecord
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
