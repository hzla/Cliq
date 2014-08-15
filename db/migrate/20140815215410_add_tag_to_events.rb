class AddTagToEvents < ActiveRecord::Migration
  def change
    add_column :events, :event_type, :string
    add_column :events, :music, :boolean
    add_column :events, :discussion, :boolean
    add_column :events, :activity, :boolean
    add_column :events, :party, :boolean
    add_column :events, :food, :boolean
    add_column :events, :games, :boolean
    add_column :events, :show, :boolean
    add_column :events, :twenty_one, :boolean
    add_column :events, :paid, :boolean
  end
end
