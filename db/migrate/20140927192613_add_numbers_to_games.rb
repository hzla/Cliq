class AddNumbersToGames < ActiveRecord::Migration
  def change
    add_column :games, :numbers, :string
  end
end
