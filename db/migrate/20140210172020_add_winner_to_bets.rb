class AddWinnerToBets < ActiveRecord::Migration
  def change
    add_column :bets, :winner_id, :integer
  end
end
