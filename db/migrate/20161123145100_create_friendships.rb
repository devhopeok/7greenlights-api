class CreateFriendships < ActiveRecord::Migration
  def change
    create_view :friendships,  materialized: true
  end
end
