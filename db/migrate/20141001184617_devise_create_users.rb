# encoding: utf-8

class DeviseCreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      ## Database authenticable
      t.string :email,              null: true,  default: ""
      t.string :encrypted_password, null: false, default: ""

      ## Recoverable
      t.string   :reset_password_token
      t.datetime :reset_password_sent_at

      t.string   :authentication_token,   default: ""

      ## User attributes
      t.string   :first_name,             default: ""
      t.string   :last_name,              default: ""
      t.string   :username,               default: ""

      t.timestamps
    end

    add_index :users, :email,                unique: true
    add_index :users, :reset_password_token, unique: true
    add_index :users, :authentication_token, unique: true
    add_index :users, :username,             unique: false
  end
end
