class ShuffledOverviewKeyword < ApplicationRecord
  ## validation
  validates :keyword_id, uniqueness: { scope: :shuffled_overview_id, message: "has already been added to this shuffled overview" }
  # 特定の ShuffledOverview に対して Keyword が一意である

  ## association
  belongs_to :shuffled_overview
  belongs_to :keyword
end
