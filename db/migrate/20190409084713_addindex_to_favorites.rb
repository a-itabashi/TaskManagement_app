class AddindexToFavorites < ActiveRecord::Migration[5.2]
  def change
    add_index :favorites, [:task_id, :label_id], unique: true
  end
end
