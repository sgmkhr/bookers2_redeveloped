class Favorite < ApplicationRecord
  include Notifiable
  
  belongs_to :user
  belongs_to :book
  
  has_one :notification, as: :notifiable, dependent: :destroy
  
  validates :user_id, uniqueness: { scope: :book_id }
  
  after_create do
    create_notification(user_id: book.user_id)
  end
  
  def notification_message
    "投稿した#{book.title}が#{user.name}さんにいいねされました"
  end 
  
  def notification_path
    user_path(user)
  end 
end
