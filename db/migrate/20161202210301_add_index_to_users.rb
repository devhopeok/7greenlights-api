class AddIndexToUsers < ActiveRecord::Migration
  def change
    add_index :reports, :user_id
    add_index :reports, :media_content_id
  end
end
