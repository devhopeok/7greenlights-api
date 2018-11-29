class CreateArenas < ActiveRecord::Migration
  def change
    create_table :arenas do |t|
      t.string :name, null: true,  default: ""
      t.string :image
      t.string :description, default: ""
      t.timestamp :end_date, null: false

      t.timestamps
    end
    add_index :arenas, :name, unique: true
  end
end
