class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true
  validates :priority, presence: true

  enum priority: {high: 0, middle: 1, low: 2}

  belongs_to :user

  has_many :favorites, dependent: :destroy

  has_many :labels
  has_many :favorites_labels, through: :favorites, source: :label

  accepts_nested_attributes_for :favorites, allow_destroy: true

end
