class CreateSponsors < ActiveRecord::Migration
  def change
    create_table :sponsors do |t|
      t.string :name
      t.string :picture
      t.string :url
    end

    create_table :arenas_sponsors, id: false do |t|
      t.belongs_to :arena, index: true
      t.belongs_to :sponsor, index: true
    end
  end
end
