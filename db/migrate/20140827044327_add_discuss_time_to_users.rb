class AddDiscussTimeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :discuss_time, :integer, default: 0
  end
end
