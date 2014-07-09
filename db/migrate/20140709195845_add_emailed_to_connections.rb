class AddEmailedToConnections < ActiveRecord::Migration
  def change
    add_column :connections, :emailed, :boolean, default: false
  end
end
