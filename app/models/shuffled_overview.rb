class ShuffledOverview < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  has_many :bookmark_of_shuffled_overviews
  has_many :users, through: :bookmark_of_shuffled_overviews
end