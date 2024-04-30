class Book < ApplicationRecord
  include Notifiable

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :view_counts, dependent: :destroy

  has_many :notifications, as: :notifiable, dependent: :destroy

  #has_many :week_favorites, -> { where(created_at: 1.week.ago.beginning_of_day..Time.current.end_of_day) }

  validates :title, presence: true
  validates :body, presence: true, length: { maximum:200 }

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

  scope :created_days_ago, -> (n) { where(created_at: n.day.ago.all_day) }
  
  scope :latest, -> { order(created_at: :desc) }
  scope :old, -> { order(created_at: :asc) }
  scope :star_count, -> { order(star: :desc) }

  validates :category, presence: true

  def favorited_by?(user)
    favorites.exists?(user_id: user.id)
  end

  def self.search_for(content, method)
    if method == 'perfect'
      Book.where(title: content)
    elsif method == 'forward'
      Book.where('title LIKE ?', content + '%')
    elsif method == 'backward'
      Book.where('title LIKE ?', '%' + content)
    else
      Book.where('title LIKE ?', '%' + content + '%')
    end
  end

  after_create do
    records = user.followers.map do |follower|
      notifications.new(user_id: follower.id)
    end
    Notification.import records
  end

  def notification_message
    "フォローしている#{user.name}さんが#{title}を投稿しました"
  end

  def notification_path
    book_path(self)
  end
  
  def self.past_week_count
    (1..6).map { |n| created_days_ago(n).count }.reverse.push(created_today.count)
  end

end
