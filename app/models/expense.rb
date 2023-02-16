class Expense < ApplicationRecord
  belongs_to :company
  belongs_to :vendor
  belongs_to :head_of_account
  belongs_to :user

  def attributes
  {
    'id' => id,
    'title' => title,
    'amount' => amount,
    'description' => description,
    'sales_tax' => sales_tax,
    'witholding_tax' => witholding_tax,
    'created_at' => created_at,
    'vendor' => vendor.attributes,
    'head_of_account' => head_of_account,
    'user' => user
  }
  end
end
