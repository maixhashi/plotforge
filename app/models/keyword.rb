class Keyword < ApplicationRecord
  has_many :shuffled_overview_keywords
  has_many :shuffled_overviews, through: :shuffled_overview_keywords
  
  validates :content, presence: true, uniqueness: true
end