class AddClosedToEvents < ActiveRecord::Migration
  def change
    add_column :events, :closed, :string, default: "closed"
  end
end
