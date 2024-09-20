class BookmarkOfMovie < ApplicationRecord
  ## Validation
  validates :user_id, uniqueness: { scope: :movie_id }
  
  ## Association  
  belongs_to :user
  belongs_to :movie
end