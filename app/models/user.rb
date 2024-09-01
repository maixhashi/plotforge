class User < ApplicationRecord
  authenticates_with_sorcery!
  mount_uploader :avatar, AvatarUploader

  include Hashid::Rails
  
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  validates :email, uniqueness: true
  
  has_many :shuffled_overviews, dependent: :destroy
  has_many :bookmark_of_shuffled_overviews
  has_many :bookmarked_shuffled_overviews, through: :bookmark_of_shuffled_overviews, source: :shuffled_overview
  has_many :bookmark_of_movies, dependent: :destroy
  has_many :bookmarked_movies, through: :bookmark_of_movies, source: :movie
  
  has_many :active_relationships, class_name: "Follow", foreign_key: "follower_id", dependent: :destroy
  has_many :following, through: :active_relationships, source: :followed
  
  has_many :passive_relationships, class_name: "Follow", foreign_key: "followed_id", dependent: :destroy
  has_many :followers, through: :passive_relationships, source: :follower

  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end
  
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end
  
  def following?(other_user)
    following.include?(other_user)
  end
end


