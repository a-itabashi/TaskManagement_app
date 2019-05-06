class CreateReads < ActiveRecord::Migration[5.2]
  def change
    create_table :reads do |t|
      t.references :user, foreign_key: true
      t.references :task, foreign_key: true
      t.boolean :flag, null: false, default: true
      t.timestamps
    end
    add_index :reads, [:user_id, :task_id], unique: true
  end
end
