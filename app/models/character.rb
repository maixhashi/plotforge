class Character < ApplicationRecord
  ## Validation
  validates :name, presence: true

  ## Association
  has_many :appearance_of_character, dependent: :destroy
  has_many :shuffled_overviews, through: :appearance_of_character
end
