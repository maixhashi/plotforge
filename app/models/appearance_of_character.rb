class AppearanceOfCharacter < ApplicationRecord
  ## Association
  belongs_to :character
  belongs_to :shuffled_overview
end
