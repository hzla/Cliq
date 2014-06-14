class AddStartDateToEvents < ActiveRecord::Migration
  def change
    add_column :events, :start_date, :datetime
    add_column :events, :quantity, :integer, default: 2
  end
end
