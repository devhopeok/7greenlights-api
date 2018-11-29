class AddGreenlightsCountToUser < ActiveRecord::Migration
  def change
    add_column :users, :greenlights_count, :integer, default: 0
  end
end
