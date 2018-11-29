class AddForeignKeyConstraintNotification < ActiveRecord::Migration
  def change
    remove_foreign_key :notifications, column: :sender_id
    remove_foreign_key :notifications, column: :receiver_id

    add_foreign_key :notifications, :users, column: :sender_id, on_delete: :cascade
    add_foreign_key :notifications, :users, column: :receiver_id, on_delete: :cascade
  end
end
