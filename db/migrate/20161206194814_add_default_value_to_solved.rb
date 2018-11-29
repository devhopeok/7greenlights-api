class AddDefaultValueToSolved < ActiveRecord::Migration
  def change
    change_column_default :reports, :solved, false
  end
end
