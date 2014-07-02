class AddSeenToExcursions < ActiveRecord::Migration
  def change
    add_column :excursions, :seen, :boolean, default: false
  end
end
