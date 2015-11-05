
class ExpensesController < ApplicationController

  def create
    amount      = params[:amount]
    currency    = params[:currency]
    spender_id  = params[:spender_id]
    borrower_id = params[:borrower_id]

    Expense.create(amount: amount, currency: currency, spender_id: spender_id, borrower_id: borrower_id )
    head_ok
  end

  def debts
    user = User.find(params[:user_id])
    debts = user.unpaid_debts

    render_jbuilders(debts) do |json,debt|
      debt.to_json json
    end

  end

  def all_debts
    user = User.find(params[:user_id])
    debts = user.debts

    render_jbuilders(debts) do |json,debt|
      debt.to_json json
    end

  end

  def lends
    user = User.find(params[:user_id])
    lends = user.unpaid_lends

    render_jbuilders(lends) do |json,lend|
      lend.to_json json
    end

  end

end