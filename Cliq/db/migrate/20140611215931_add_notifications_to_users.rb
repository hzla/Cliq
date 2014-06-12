class AddNotificationsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :message_count, :integer, default: 0
    add_column :users, :event_count, :integer, default: 0
    add_column :users, :invite_count, :integer, default: 0
  end
end
