class BookmarkOfShuffledOverview < ApplicationRecord
  belongs_to :user
  belongs_to :shuffled_overview

  validates :user_id, uniqueness: { scope: :shuffled_overview_id }
end
