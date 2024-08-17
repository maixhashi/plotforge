class Movie < ApplicationRecord
  has_many :link_of_shuffled_overview_movies
  has_many :shuffled_overviews, through: :link_of_shuffled_overview_movies

  has_many :bookmark_of_movies, dependent: :destroy
  has_many :bookmarked_by_users, through: :bookmark_of_movies, source: :user
end