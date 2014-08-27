class AddCreateClickCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :create_click_count, :integer, default: 0
  end
end
