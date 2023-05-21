# frozen_string_literal: true

class CreateTransactions < ActiveRecord::Migration[5.2]
  def change
    create_table :transactions do |t|
      t.references :from, index: true
      t.references :to, index: true
      t.date :date
      t.float :amount
      t.string :description
      t.string :label

      t.timestamps null: false
    end

    add_foreign_key :transactions, :accounts, column: :from_id
    add_foreign_key :transactions, :accounts, column: :to_id
  end
end
