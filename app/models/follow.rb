class Follow < ApplicationRecord
  ## Validation
  validates :follower_id, uniqueness: { scope: :followed_id, message: "You are already following this user" }

  ## Association
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
end

