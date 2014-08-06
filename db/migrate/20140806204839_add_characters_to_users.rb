class AddCharactersToUsers < ActiveRecord::Migration
  def change
    add_column :users, :characters, :string
  end
end
