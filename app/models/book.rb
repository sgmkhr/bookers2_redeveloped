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
    
end 
