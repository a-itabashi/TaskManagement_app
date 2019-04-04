class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true
  validates :priority, presence: true

  enum priority: {high: 0, middle: 1, low: 2}
end
