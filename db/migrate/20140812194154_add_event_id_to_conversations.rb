class AddEventIdToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :event_id, :integer
  end
end
