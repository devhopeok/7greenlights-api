class CreateNotes < ActiveRecord::Migration
  def change
    create_table :notes do |t|
      t.belongs_to :user, index: true
      t.belongs_to :media_content, index: true
      t.string :image

      t.timestamps
    end
  end
end
