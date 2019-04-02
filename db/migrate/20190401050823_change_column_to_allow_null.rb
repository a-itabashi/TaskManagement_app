class ChangeColumnToAllowNull < ActiveRecord::Migration[5.2]
  def up
     change_column :tasks, :title,:string, null: false
     change_column :tasks, :content,:text, null: false
  end

  def down
    change_column :tasks, :title,:string, null: false
    change_column :tasks, :content,:text, null: false
  end
end
