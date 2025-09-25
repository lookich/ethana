class CreateNotifications < ActiveRecord::Migration[8.0]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :notification_type, null: false
      t.string :reciever_type, array: true, null: false
      t.string :title
      t.string :body
      t.boolean :viewed, default: false

      t.timestamps
    end
  end
end
