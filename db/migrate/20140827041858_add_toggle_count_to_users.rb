class AddToggleCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :toggle_count, :integer, default: 0
  end
end
