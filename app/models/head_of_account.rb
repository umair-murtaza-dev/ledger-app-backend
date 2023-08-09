class HeadOfAccount < ApplicationRecord
  acts_as_paranoid
  
  belongs_to :company
  has_many :expenses

  def attributes
  {
    'id' => self.id,
    'title' => title
  }
  end
end
