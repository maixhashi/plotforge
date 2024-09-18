class ShuffledOverview < ApplicationRecord
  ## Validation
  validates :content, presence: true
  
  ## Association
  belongs_to :user
  
  has_many :bookmark_of_shuffled_overviews, dependent: :destroy
  has_many :users, through: :bookmark_of_shuffled_overviews

  has_many :link_of_shuffled_overview_movies, dependent: :destroy
  has_many :movies, through: :link_of_shuffled_overview_movies
  accepts_nested_attributes_for :link_of_shuffled_overview_movies

  has_many :appearance_of_character, dependent: :destroy
  has_many :characters, through: :appearance_of_character
  accepts_nested_attributes_for :characters
  
  has_many :shuffled_overview_keywords
  has_many :keywords, through: :shuffled_overview_keywords

  has_many :notifications, dependent: :destroy

  ## Instance Method
  def create_notification_bookmark!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and shuffled_overview_id = ? and action = ? ", current_user.id, user_id, id, 'bookmark-of-shuffled-overview'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        shuffled_overview_id: id,
        visited_id: user_id,
        action: 'bookmark-of-shuffled-overview'
      )
      # 自分の投稿に対するいいねの場合は、通知済みとする
      if notification.visitor_id == notification.visited_id
        notification.checked = true
      end
      notification.save if notification.valid?
    end
  end

  def create_notification_comment!(current_user, comment_id)
    # 自分以外にコメントしている人をすべて取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(shuffled_overview_id: id).where.not(user_id: current_user.id).distinct
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # まだ誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # コメントは複数回することが考えられるため、１つの投稿に複数回通知する
    notification = current_user.active_notifications.new(
      shuffled_overview_id: id,
      comment_id: comment_id,
      visited_id: visited_id,
      action: 'comment'
    )
    # 自分の投稿に対するコメントの場合は、通知済みとする
    if notification.visitor_id == notification.visited_id
      notification.checked = true
    end
    notification.save if notification.valid?
  end

end