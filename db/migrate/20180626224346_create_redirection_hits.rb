class CreateRedirectionHits < ActiveRecord::Migration
  def change
    create_table :redirection_hits do |t|
      t.string :origin
      t.string :path

      t.timestamps null: false
    end
  end
end
