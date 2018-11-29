class AddGreenlightsCountToArenas < ActiveRecord::Migration
  def change
    add_column :arenas, :greenlights_count, :integer, default: 0
  end
end
