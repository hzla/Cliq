class AddCatNameToInterestSuggestions < ActiveRecord::Migration
  def change
    add_column :interest_suggestions, :cat_name, :string
  end
end
