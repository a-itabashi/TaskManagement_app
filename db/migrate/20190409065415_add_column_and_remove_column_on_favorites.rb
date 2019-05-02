class AddColumnAndRemoveColumnOnFavorites < ActiveRecord::Migration[5.2]
  def change
    remove_column :favorites, :task_id, :integer
    remove_column :favorites, :label_id, :integer
  end
end
