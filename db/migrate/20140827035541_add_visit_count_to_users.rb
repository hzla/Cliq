class AddVisitCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :visit_count, :integer, default: 1
  end
end
