class CreatePosts < ActiveRecord::Migration[6.1]
  def change
    create_table :posts do |t|
      t.string :title, null: false
      t.text :body, null: false
      t.boolean :is_active, null: false, default: true
      t.boolean :is_banned, null: false, default: false
      t.references :genre, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :child, null: false, foreign_key: true

      t.timestamps
    end
  end
end
