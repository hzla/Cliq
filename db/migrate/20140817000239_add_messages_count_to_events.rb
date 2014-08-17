class AddMessagesCountToEvents < ActiveRecord::Migration
  def change
    add_column :events, :messages_count, :integer, default: 0
  end
end
