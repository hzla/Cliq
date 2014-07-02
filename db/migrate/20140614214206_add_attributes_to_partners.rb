class AddAttributesToPartners < ActiveRecord::Migration
  def change
  	add_column :partners, :location, :string
  	add_column :partners, :mon, :string
  	add_column :partners, :tues, :string
  	add_column :partners, :wed, :string
  	add_column :partners, :thurs, :string
  	add_column :partners, :fri, :string
  	add_column :partners, :sat, :string
  	add_column :partners, :sun, :string
  end
end
