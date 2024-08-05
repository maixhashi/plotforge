class User < ApplicationRecord
  authenticates_with_sorcery!
  
  validates :password, length: { minimum: 3 }, if: -> { new_record? || changes[:crypted_password] }
  validates :password, confirmation: true, if: -> { new_record? || changes[:crypted_password] }
  validates :password_confirmation, presence: true, if: -> { new_record? || changes[:crypted_password] }
  
  validates :email, uniqueness: true
  has_many :shuffled_overviews, dependent: :destroy
  has_many :bookmark_of_shuffled_overviews
  has_many :bookmarked_shuffled_overviews, through: :bookmark_of_shuffled_overviews, source: :shuffled_overview
end