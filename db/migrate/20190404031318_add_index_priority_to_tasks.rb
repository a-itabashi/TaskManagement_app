class AddIndexPriorityToTasks < ActiveRecord::Migration[5.2]
  def change
    add_index :tasks, :priority
  end
end
