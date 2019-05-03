class CreateGroups < ActiveRecord::Migration[5.2]
  def change
    create_table :groups do |t|
      t.string :name
      t.integer :owner_id

      t.timestamps
    end
    add_index :groups, :owner_id
  end
end
