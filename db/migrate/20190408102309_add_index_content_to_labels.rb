class AddIndexContentToLabels < ActiveRecord::Migration[5.2]
  def change
    add_index :labels, :content, :unique => true
  end
end
