class AddDeadlineToTasks < ActiveRecord::Migration[5.2]
  def change
    add_column :tasks, :deadline, :datetime, :null => false, default: -> { 'CURRENT_TIMESTAMP' }
  end
end
