class AddEventViewCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :event_view_count, :integer, default: 0
  end
end
