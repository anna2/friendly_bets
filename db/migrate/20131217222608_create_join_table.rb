class CreateJoinTable < ActiveRecord::Migration
  def change
    create_table :positions do |t|
      t.belongs_to :user
      t.belongs_to :bet

      t.boolean :admin
      t.string :position
    end
  end
end
