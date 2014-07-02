class CreateLocationSuggestions < ActiveRecord::Migration
  def change
    create_table :location_suggestions do |t|
      t.string :term
      t.integer :popularity
      t.integer :location_id
      t.timestamps
    end
  end
end
