class AddBlacklistToUsers < ActiveRecord::Migration
  def change
    add_column :users, :blacklist, :text, default: "0"
  end
end
