class CreatePosts < ActiveRecord::Migration
  def change
    create_table :posts do |t|
      t.belongs_to :arena,         index: true
      t.belongs_to :media_content, index: true
      t.belongs_to :user,          index: true

      t.timestamps
    end
  end
end
