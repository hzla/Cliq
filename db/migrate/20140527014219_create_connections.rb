class CreateConnections < ActiveRecord::Migration
  def change
    create_table :connections do |t|
    	t.references :user, null: false
    	t.references :conversation, null: false
    end

    add_index :connections, [:user_id, :conversation_id]
  end
end
