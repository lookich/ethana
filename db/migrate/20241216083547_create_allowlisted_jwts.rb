class CreateAllowlistedJwts < ActiveRecord::Migration[8.0]
  def change
    create_table :allowlisted_jwts do |t|
      t.string :jti, null: false
      t.string :aud
      t.datetime :exp, null: false
      t.string :remote_ip
      t.string :os_data
      t.string :browser_data
      t.string :device_data
      t.references :user, foreign_key: { on_delete: :cascade }, null: false

      t.timestamps
    end

    add_index :allowlisted_jwts, :jti, unique: true
  end
end
