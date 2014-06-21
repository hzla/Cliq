class CreateActivities < ActiveRecord::Migration 
  def change
    create_table :activities do |t|
    	t.string :name
    	t.integer :category_id

    	t.timestamps
    end

    add_index :activities, :category_id, :name => 'category_id_ix'
  end


end
