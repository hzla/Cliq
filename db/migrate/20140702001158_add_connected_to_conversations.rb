class AddConnectedToConversations < ActiveRecord::Migration
  def change
    add_column :conversations, :connected, :boolean, default: false
  end
end
