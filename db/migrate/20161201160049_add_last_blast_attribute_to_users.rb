class AddLastBlastAttributeToUsers < ActiveRecord::Migration
  def change
    add_column :users, :last_blast, :string
  end
end
