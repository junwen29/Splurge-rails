class Expense < ActiveRecord::Base

  belongs_to :spender, :class_name => 'User'
  belongs_to :borrower, :class_name => 'User'

  include Expense::Json

end
