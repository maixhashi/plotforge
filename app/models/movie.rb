class Movie < ApplicationRecord
  ## Validation
  validates :tmdb_id, presence: true

  ## Association
  has_many :link_of_shuffled_overview_movies
  has_many :shuffled_overviews, through: :link_of_shuffled_overview_movies

  has_many :bookmark_of_movies, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmark_of_movies, source: :user

  has_many :notifications, dependent: :destroy

  ## Instance Method 
  def create_notification_bookmark!(current_user)
    # すでに「いいね」されているか検索
    temp = Notification.where(["visitor_id = ? and visited_id = ? and movie_id = ? and action = ? ", current_user.id, user_id, id, 'bookmark-of-movie'])
    # いいねされていない場合のみ、通知レコードを作成
    if temp.blank?
      notification = current_user.active_notifications.new(
        movie_id: id,
        visited_id: user_id,
        action: 'bookmark-of-movie'
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