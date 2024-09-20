class Keyword < ApplicationRecord
  ## Validation
  validates :content, presence: true
  # validates :content, uniqueness: true

  ## Association
  has_many :shuffled_overview_keywords
  has_many :shuffled_overviews, through: :shuffled_overview_keywords
end