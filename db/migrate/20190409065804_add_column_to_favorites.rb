class AddColumnToFavorites < ActiveRecord::Migration[5.2]
  def change
    add_column :favorites, :task_id, :bigint
    add_column :favorites, :label_id, :bigint
  end
end
