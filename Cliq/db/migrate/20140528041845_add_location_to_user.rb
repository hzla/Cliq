class AddLocationToUser < ActiveRecord::Migration
  def change
    add_column :users, :latitude, :float
    add_column :users, :longitude, :float
    add_column :users, :address, :string
    add_column :users, :sex, :string
    add_column :users , :sexual_preference, :string, default: "hetero"
  end
end
