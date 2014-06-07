class AddAttendedToExcursions < ActiveRecord::Migration
  def change
  	add_column :excursions, :attended, :boolean, default: false
  end
end
