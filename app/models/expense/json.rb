module Expense::Json
  extend ActiveSupport::Concern

  included do

    def to_json(json, options = {})
      json.id         self.id
      json.isSettled  self.isSettled
      json.amount     self.amount

      json.borrower do
        json.id       self.borrower.id
        json.username self.borrower.username
        json.email    self.borrower.email
      end

      json.spender do
        json.id       self.spender.id
        json.username self.spender.username
        json.email    self.spender.email
      end

    end

  end
end