class AddTooltipsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :tooltips, :json
  end
end
