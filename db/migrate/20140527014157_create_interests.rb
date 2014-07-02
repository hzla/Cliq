class CreateInterests < ActiveRecord::Migration
  def change
    create_table :interests do |t|
    	t.references :user, null: false
    	t.references :activity, null: false
    end

    add_index :interests, [:user_id, :activity_id]
  end


end

