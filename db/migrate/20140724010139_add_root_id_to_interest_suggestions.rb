class AddRootIdToInterestSuggestions < ActiveRecord::Migration
  def change
    add_column :interest_suggestions, :root_id, :integer
  end
end
