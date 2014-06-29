class CreateUsers < ActiveRecord::Migration
    def change
        create_table :users do |t|
            t.string :name, :username, :password, :email
            t.timestamps
        end
        create_table :tasks do |t|
            t.string :name, :location
            t.datetime :due
            t.integer :user_id, :circle_id
            t.timestamps
      end
        create_table :alerts do |t|
            t.string :message
            t.integer :user_id, :creator_id
        end
        create_table :circles do |t|
            t.string :name
            t.boolean :private, default: true
            t.integer :creator_id
            t.timestamps
        end
        create_table :circles_users, id: false do |t|
            t.belongs_to :user
            t.belongs_to :circle
        end
    end
end