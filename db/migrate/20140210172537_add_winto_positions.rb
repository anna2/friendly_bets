class AddWintoPositions < ActiveRecord::Migration
  def change
    add_column :positions, :win, :boolean
  end
end
