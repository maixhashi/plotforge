class LinkOfShuffledOverviewMovie < ApplicationRecord
  ## Validation 
  validates :shuffled_overview_id, uniqueness: { scope: :movie_id }

  ## Association
  belongs_to :shuffled_overview
  belongs_to :movie
end