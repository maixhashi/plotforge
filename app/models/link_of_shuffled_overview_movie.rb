class LinkOfShuffledOverviewMovie < ApplicationRecord
  ## Association
  belongs_to :shuffled_overview
  belongs_to :movie
end