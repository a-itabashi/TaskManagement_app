class Favorite < ApplicationRecord
  belongs_to :task
  belongs_to :label

  validates_uniqueness_of :task_id, scope: :label_id

  scope :between, -> (task_id,label_id) do
    where("(favorites.task_id = ? AND favorites.label_id =?) OR (favorites.task_id = ? AND  favorites.label_id =?)", task_id,label_id, label_id, task_id)
  end
end
