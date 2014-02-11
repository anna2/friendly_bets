class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.attachment :photo
      t.text :text

      t.references :user
      t.references :bet

      t.timestamps
    end
  end
end
