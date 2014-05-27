class CreateActivities < ActiveRecord::Migration
  def change
    create_table :activities do |t|
    	t.string :name
    	t.string :category

    	t.timestamps
    end
  end
end
