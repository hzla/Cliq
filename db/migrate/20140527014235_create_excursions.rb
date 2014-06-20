class CreateExcursions < ActiveRecord::Migration
  def change
    create_table :excursions do |t|
    	t.references :user, null: false
    	t.references :event, null: false
    end

    add_index :excursions, [:user_id, :event_id]
  end
end
