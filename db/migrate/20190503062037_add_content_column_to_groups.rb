class AddContentColumnToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :content, :text, null: false
  end
end
