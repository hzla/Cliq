class AddInitiatedToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :initiated, :boolean, default: false
  end
end
