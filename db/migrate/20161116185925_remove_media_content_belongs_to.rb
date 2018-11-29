class RemoveMediaContentBelongsTo < ActiveRecord::Migration
  def change
    remove_reference :media_contents, :arena, index: true
  end
end
