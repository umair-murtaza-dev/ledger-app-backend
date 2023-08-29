class Account < ApplicationRecord
  acts_as_paranoid

  belongs_to :user
  belongs_to :head_of_account, optional: true
  belongs_to :expense, optional: true

  validates :title, presence: true
  validates :title, uniqueness: { case_senstitive: false }

  enum account_type: {
    " ": nil,
    current: 1,
    savings: 2,
  }, _prefix: true

  def attributes
  {
    'id' => self.id,
    'title' => title,
    'bank_name' => bank_name,
    'account_no' => account_no,
    'iban' => iban,
    'currency' => currency,
    'account_type' => account_type,
    'balance' => balance,
    'head_of_account_title' => head_of_account_title,
    'user_name' => user_name,
  }
  end

  def head_of_account_title
    self.head_of_account&.title
  end

  def user_name
    self.user.firstname + " " + self.user.lastname
  end

  def self.apply_filter(query)
    accounts = where("lower(accounts.title) LIKE :term", term: "%#{query.downcase}%")
    accounts
  end
end
