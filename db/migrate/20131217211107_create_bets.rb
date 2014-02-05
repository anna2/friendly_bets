class CreateBets < ActiveRecord::Migration
  def change
    create_table :bets do |t|
      t.string :title
      t.string :description
      t.integer :amount

      t.timestamps
    end
  end
end
