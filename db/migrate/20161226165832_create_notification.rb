class CreateNotification < ActiveRecord::Migration
  def change
    create_table :notifications do |t|
      t.belongs_to :event_entity, polymorphic: true, index: true
      t.integer :sender_id, index: true
      t.integer :receiver_id, index: true
      t.string :type

      t.timestamps
    end

    add_foreign_key :notifications, :users, column: :sender_id
    add_foreign_key :notifications, :users, column: :receiver_id
  end
end
