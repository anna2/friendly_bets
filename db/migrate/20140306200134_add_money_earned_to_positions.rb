class AddMoneyEarnedToPositions < ActiveRecord::Migration
  def change
    add_column :positions, :money_earned, :integer
    add_column :positions, :money_lost, :integer
  end
end
