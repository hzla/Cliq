class AddAltTextToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :question, :string
    add_column :categories, :alt_text, :string
  end
end
