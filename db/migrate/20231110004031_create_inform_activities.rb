class CreateInformActivities < ActiveRecord::Migration[6.1]
  def change
    create_table :inform_activities do |t|
      t.references :user, foreign_key: true
      t.references :subject, polymorphic: true
      t.integer :action_type, null: false
      t.boolean :is_unread, null: false, default: true

      t.timestamps
    end
  end
end
