class AddCatIdToInterestSuggestions < ActiveRecord::Migration
  def change
    add_column :interest_suggestions, :cat_id, :integer
  end
end
