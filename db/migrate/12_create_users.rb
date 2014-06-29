class CreateUsers < ActiveRecord::Migration
  def change
  	create_table :users do |t|
  		t.string :name, :username, :password, :email
  		t.timestamps
  	end
      create_table :tasks do |t|
            t.string :name, :location
            t.datetime :due
            t.integer :user_id
            t.timestamps
      end
      create_table :circles do |t|
            t.string :name
            t.boolean :private, default: false
            t.integer :creator_id
      end
      create_table :circles_users, id: false do |t|
            t.belongs_to :user
            t.belongs_to :circle
      end
    end
  end