class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  mount_uploader :avatar, AvatarUploader

  include FriendlyId
  friendly_id :name

  validates :email, uniqueness: true
  validates :email, presence: true

  validates :password, length: { minimum: 3 }, if: -> { password.present? || new_record? || changes[:crypted_password] }
  validates :password, presence: true, if: -> { password.present? || new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { password.present? || new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { password.present? || new_record? || changes[:crypted_password] }
  
  has_many :shuffled_overviews, dependent: :destroy
  has_many :bookmark_of_shuffled_overviews
  has_many :bookmarked_shuffled_overviews, through: :bookmark_of_shuffled_overviews, source: :shuffled_overview
  has_many :bookmark_of_movies, dependent: :destroy
  has_many :bookmarked_movies, through: :bookmark_of_movies, source: :movie
  
  has_many :active_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  
  has_many :passive_relationships, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  has_many :active_notifications, class_name: 'Notification', foreign_key: 'visitor_id', dependent: :destroy
  has_many :passive_notifications, class_name: 'Notification', foreign_key: 'visited_id', dependent: :destroy

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def following?(other_user)
    following.include?(other_user)
  end

  def create_notification_follow!(current_user)
    temp = Notification.where(["visitor_id = ? and visited_id = ? and action = ? ",current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(
        visited_id: id,
        action: 'follow'
      )
      notification.save if notification.valid?
    end
  end
end


