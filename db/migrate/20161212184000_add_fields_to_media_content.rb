class AddFieldsToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :username, :string
    add_column :media_contents, :content_type, :integer, default: 0

    add_index :media_contents, :username
    add_index :media_contents, :content_type
  end
end
