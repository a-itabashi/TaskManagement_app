class RenameFromTypeToContentOnLabels < ActiveRecord::Migration[5.2]
  def change
    rename_column :labels, :type, :content
  end
end
