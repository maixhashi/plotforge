class Movie < ApplicationRecord
  has_many :link_of_shuffled_overview_movies
  has_many :shuffled_overviews, through: :link_of_shuffled_overview_movies
end
