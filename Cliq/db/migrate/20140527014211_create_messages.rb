class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
    	t.text :body
    	t.integer :user_id
    	t.integer :conversation_id
    	t.timestamps
    end

    add_index :messages, :user_id, :name => 'msg_user_id_ix'
  end
end
