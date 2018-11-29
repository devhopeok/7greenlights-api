class AddGreenlightsCountToMediaContent < ActiveRecord::Migration
  def change
    add_column :media_contents, :greenlights_count, :integer, default: 0
  end
end
