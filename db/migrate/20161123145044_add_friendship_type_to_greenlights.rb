class AddFriendshipTypeToGreenlights < ActiveRecord::Migration
  def change
    add_column :greenlights, :friendship_status, :integer, default: 0
  end
end
