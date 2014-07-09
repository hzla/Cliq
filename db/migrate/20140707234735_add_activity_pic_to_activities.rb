class AddActivityPicToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :activity_pic, :string
  end
end
