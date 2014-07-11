class AddSuggestedByToActivities < ActiveRecord::Migration
  def change
    add_column :activities, :suggested_by, :integer
  end
end
