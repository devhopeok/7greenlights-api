class CreateArenaContentGreenlightsCounts < ActiveRecord::Migration
  def change
    create_view :arena_content_greenlights_counts, materialized: true
  end
end
