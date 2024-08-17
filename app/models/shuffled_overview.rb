class ShuffledOverview < ApplicationRecord
  belongs_to :user
  validates :content, presence: true
  has_many :bookmark_of_shuffled_overviews, dependent: :destroy
  has_many :users, through: :bookmark_of_shuffled_overviews
  has_many :link_of_shuffled_overview_movies, dependent: :destroy
  has_many :movies, through: :link_of_shuffled_overview_movies
  accepts_nested_attributes_for :link_of_shuffled_overview_movies
end

