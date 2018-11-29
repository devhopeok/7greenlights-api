class AddChannelToUser < ActiveRecord::Migration
  def change
    add_column :users, :channel, :text
  end
end
