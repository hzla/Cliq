class AddNotifyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :notify_messages, :boolean, default: true
    add_column :users, :notify_events, :boolean, default: true
    add_column :users, :notify_news, :boolean, default: true
  end
end
