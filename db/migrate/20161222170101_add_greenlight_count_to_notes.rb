class AddGreenlightCountToNotes < ActiveRecord::Migration
  def change
    add_column :notes, :greenlights_count, :integer
  end
end
