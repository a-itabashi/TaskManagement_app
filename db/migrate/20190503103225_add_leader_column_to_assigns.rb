class AddLeaderColumnToAssigns < ActiveRecord::Migration[5.2]
  def change
    add_column :assigns, :leader, :boolean, null: false, default: false
  end
end
