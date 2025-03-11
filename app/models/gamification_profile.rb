class GamificationProfile < ApplicationRecord
  belongs_to :user
  
  validates :user_id, presence: true, uniqueness: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :level, numericality: { only_integer: true, greater_than: 0 }
  
  def add_points(amount)
    self.points += amount
    check_level_up
    save
  end
  
  private
  
  def check_level_up
    # Simple level calculation: level = sqrt(points / 100)
    new_level = Math.sqrt(points / 100.0).floor + 1
    self.level = new_level if new_level > level
  end
end
