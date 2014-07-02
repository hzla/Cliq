class CreateCatInterest < ActiveRecord::Migration
  def change
    create_table :cat_interests do |t|
    	t.references :user, null: false
    	t.references :category, null: false
    end

    add_index :cat_interests, [:user_id, :category_id]
  end
end
