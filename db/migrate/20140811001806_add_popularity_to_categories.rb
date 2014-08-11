class AddPopularityToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :popularity, :integer, default: 0
  end
end
