class AddBlastToArena < ActiveRecord::Migration
  def change
    add_column :arenas, :blast, :text
  end
end
