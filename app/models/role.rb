class Role < ApplicationRecord
  acts_as_paranoid

  has_many :users

  validates :title, presence: true
  validates :title, uniqueness: { case_senstitive: false }

  def attributes
  {
    'id' => self.id,
    'title' => title,
    'is_company_admin' => is_company_admin,
    'is_admin' => is_admin
  }
  end

  def self.apply_filter(query)
    roles = where("lower(roles.title) LIKE :term", term: "%#{query.downcase}%")
    roles
  end
end
