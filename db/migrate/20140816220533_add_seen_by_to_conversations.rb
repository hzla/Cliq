class AddSeenByToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :seen_by, :text
  end
end
