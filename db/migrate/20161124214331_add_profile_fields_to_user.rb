class AddProfileFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :picture, :string
    add_column :users, :social_media_links, :json
    add_column :users, :about, :text
    add_column :users, :goals, :text
  end
end
