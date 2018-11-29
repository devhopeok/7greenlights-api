class CreateBlasts < ActiveRecord::Migration
  def change
    create_table :blasts do |t|
      t.belongs_to :user, index: true
      t.string     :text

      t.timestamps
    end
  end
end
