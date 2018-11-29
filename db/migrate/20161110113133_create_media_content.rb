class CreateMediaContent < ActiveRecord::Migration
  def change
    create_table :media_contents do |t|
      t.string  :name
      t.string  :media_url
      t.json    :links
      t.boolean :is_hidden, default: false

      t.timestamps

      t.belongs_to :arena, index: true
      t.belongs_to :user, index: true
    end

    add_index :media_contents, [:arena_id, :name], unique: true
    add_index :media_contents, :is_hidden
  end
end
