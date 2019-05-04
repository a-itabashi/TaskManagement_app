class AddUniqueIndexToAssings < ActiveRecord::Migration[5.2]
  def change
    add_index :assigns, [:user_id, :group_id], unique: true
  end
end
