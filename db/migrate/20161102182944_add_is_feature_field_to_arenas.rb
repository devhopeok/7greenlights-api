class AddIsFeatureFieldToArenas < ActiveRecord::Migration
  def change
    add_column :arenas, :is_feature, :boolean, default: false
  end
end
