class CreateFollowers < ActiveRecord::Migration
  def change
    create_view :followers
  end
end
