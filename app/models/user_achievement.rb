class UserAchievement < ApplicationRecord
  belongs_to :gamification_profile
  belongs_to :achievement
  
  validates :gamification_profile_id, uniqueness: { scope: :achievement_id }
end
