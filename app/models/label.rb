class Label < ApplicationRecord
  belongs_to :task,optional: true

  has_many :favorites, dependent: :destroy

  has_many :favorite_tasks, through: :favorites, source: :task

  belongs_to :user

  validates :content, presence: true, uniqueness: true
end
