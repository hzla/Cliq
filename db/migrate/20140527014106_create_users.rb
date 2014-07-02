class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
    	t.string :name
    	t.string :email
    	t.string :school
        t.string :profile_pic_url
        t.string :fb_token
        t.string :activation
    	t.text :bio
    	t.timestamps
    end
  end
end
