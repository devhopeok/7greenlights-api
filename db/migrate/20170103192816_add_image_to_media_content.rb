class AddImageToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :image, :string
  end
end
