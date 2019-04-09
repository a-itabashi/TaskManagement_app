class RemoveTaskIdFromLabels < ActiveRecord::Migration[5.2]
  def change
    remove_column :labels, :task_id, :integer
  end
end
