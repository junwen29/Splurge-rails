
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

  def all_lends
    user = User.find(params[:user_id])
    lends = user.lends

    render_jbuilders(lends) do |json,lend|
      lend.to_json json
    end

  end

  def update
    expense = Expense.find(params[:expense_id])
    expense.update(isSettled: true)

    borrower = expense.borrower
    tokens = DeviceService.tokens_by_user(borrower.id)

    notification = borrower.notifications.create(item_type: 'expense',
                                             item_id: expense.id,
                                             item_name: 'Settlement',
                                             message: 'Your debt with ' + expense.spender.username.to_s + ' is settled.')

    NotificationService.send_notification_by_user(notification.id, tokens)

    head_ok
  end

end