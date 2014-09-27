class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.string :name
      t.integer :creator_id
      t.boolean :won, default: false
      t.integer :winner_id
      t.integer :loser_id
      t.integer :points, default: 0
      t.timestamps
    end
  end
end
