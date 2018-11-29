class AddIndexToIsFeatureArena < ActiveRecord::Migration
  def change
    add_index :arenas, :is_feature, where: 'is_feature=true'
  end
end
