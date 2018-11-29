class AddIndexToSocialMediaFields < ActiveRecord::Migration
  def change
    add_index :users, :facebook_id, unique: true
    add_index :users, :instagram_id, unique: true

  end
end
