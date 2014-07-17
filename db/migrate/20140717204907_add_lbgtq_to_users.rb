class AddLbgtqToUsers < ActiveRecord::Migration
  def change
    add_column :users, :lbgtq, :boolean, default: false
  end
end
