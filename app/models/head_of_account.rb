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

  def self.apply_filter(query)
    head_of_accounts = where("lower(head_of_accounts.code) LIKE :term OR lower(head_of_accounts.title) LIKE :term", term: "%#{query.downcase}%")
    head_of_accounts
  end
end
