class Expense < ApplicationRecord
  belongs_to :company
  belongs_to :vendor
  belongs_to :head_of_account
  belongs_to :user
end
