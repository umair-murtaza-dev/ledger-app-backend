class HeadOfAccount < ApplicationRecord
  belongs_to :company
  has_many :expenses

  def attributes
  {
    'id' => self.id,
    'title' => title
  }
  end
end
