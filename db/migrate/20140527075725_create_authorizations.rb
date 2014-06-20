class CreateAuthorizations < ActiveRecord::Migration
  def change
    create_table :authorizations do |t|
      t.string :provider, default: "facebook"
      t.string :uid
      t.integer :user_id

      t.timestamps
    end
  end
end
