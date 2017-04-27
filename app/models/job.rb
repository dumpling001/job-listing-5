class Job < ApplicationRecord
  has_many :resumes
  has_many :likes
  belongs_to :workplace
  belongs_to :user

  has_many :job_to_user
  has_many :members, through: :job_to_user, source: :user

  validates :title, presence: true
  validates :wage_upper_bound, presence: true
  validates :wage_lower_bound, presence: true
  validates :wage_lower_bound, numericality: { greater_than: 0}
  validates :wage_upper_bound, numericality: { greater_than: :wage_lower_bound}

  def publish!
    self.is_hidden = false
    self.save
  end

  def hide!
    self.is_hidden = true
    self.save
  end
  scope :published, -> { where(is_hidden: false) }
  scope :recent, -> { order('created_at DESC') }
end
