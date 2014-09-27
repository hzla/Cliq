class AddGameAttributesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :wins, :string, default: 0
    add_column :users, :losses, :string, default: 0
    add_column :users, :points, :integer, default: 0
  end
end
