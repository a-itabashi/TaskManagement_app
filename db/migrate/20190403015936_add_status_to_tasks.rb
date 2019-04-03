class AddStatusToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :status, :string

    add_index :tasks, :title
    add_index :tasks, :status
  end
end
