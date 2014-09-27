class AddAdditionsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :additions, :text, default: ""
  end
end
