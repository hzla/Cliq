class AddViewsToEvents < ActiveRecord::Migration
  def change
    add_column :events, :views, :integer, default: 0
  end
end
