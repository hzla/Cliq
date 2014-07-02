class CreateInterestSuggestions < ActiveRecord::Migration
  def change
    create_table :interest_suggestions do |t|
      t.string :term
      t.integer :popularity
      t.string :interest_id
    end
  end
end
