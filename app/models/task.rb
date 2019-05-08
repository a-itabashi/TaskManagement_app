class Task < ApplicationRecord
  validates :title, presence: true
  validates :content, presence: true
  validates :deadline, presence: true
  validates :priority, presence: true

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorites_labels, through: :favorites, source: :label
  has_many :reads, dependent: :destroy
  has_one_attached :image

  enum priority: {high: 0, middle: 1, low: 2}

  # controller
  def self.announce_deadline
    where("deadline <= ?", (Time.zone.today+7.day)).where("status != ?", "完了")
  end

  # view
  def deadline_column
    self.deadline.strftime("%Y年%m月%d日")
  end
end
