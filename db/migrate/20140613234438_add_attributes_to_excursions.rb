class AddAttributesToExcursions < ActiveRecord::Migration
  def change
    add_column :excursions, :created, :boolean, default: false
    add_column :excursions, :accepted, :boolean, default: false
    add_column :excursions, :passed, :boolean, default: false
  end
end
