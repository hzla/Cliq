class AddHasPicToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :has_pic, :boolean, default: false
  end
end
