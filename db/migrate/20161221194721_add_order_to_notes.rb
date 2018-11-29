class AddOrderToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :order, :integer, default: 0
    add_column :notes, :is_feature, :boolean, default: false

    add_index :notes, :order
    add_index :notes, :is_feature
  end
end
