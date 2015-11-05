class CreateExpenses < ActiveRecord::Migration
  def change
    create_table :expenses do |t|
      t.string :amount
      t.string :currency
      t.boolean :isSettled, :default => false

      t.references :spender
      t.references :borrower

      t.timestamps null: false
    end
  end
end
