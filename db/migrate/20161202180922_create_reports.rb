class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.belongs_to :user
      t.belongs_to :media_content
      t.text :message
      t.boolean :solved

      t.timestamps
    end
  end
end
