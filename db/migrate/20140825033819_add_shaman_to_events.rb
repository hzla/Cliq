class AddShamanToEvents < ActiveRecord::Migration
  def change
    add_column :events, :shaman, :boolean
  end
end
