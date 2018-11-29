class CreateGreenlights < ActiveRecord::Migration
  def change
    create_table :greenlights do |t|
     t.belongs_to :user, index: true
     t.references :greenlighteable, polymorphic: true, index: { name: 'index_greenlighteable' }
     t.timestamps
    end
  end
end
