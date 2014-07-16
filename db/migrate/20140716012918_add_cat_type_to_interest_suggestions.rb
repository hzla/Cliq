class AddCatTypeToInterestSuggestions < ActiveRecord::Migration
  def change
    add_column :interest_suggestions, :cat_type, :string
  end
end
