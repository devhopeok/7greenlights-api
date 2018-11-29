class ChangeUserJsonToJsonB < ActiveRecord::Migration
  def change
    change_column :users, :tooltips, :jsonb, using: 'CAST(tooltips AS jsonb)'
    change_column :users, :social_media_links, :jsonb, using: 'CAST(social_media_links AS jsonb)'
  end
end
