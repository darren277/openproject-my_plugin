class GamificationProfile < ApplicationRecord
  belongs_to :user

  has_many :gamification_activities, dependent: :destroy
  has_many :user_achievements, dependent: :destroy
  has_many :achievements, through: :user_achievements
  
  validates :user_id, presence: true, uniqueness: true
  validates :points, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :level, numericality: { only_integer: true, greater_than: 0 }

  # Rank titles based on level
  RANKS = {
    1 => 'Beginner',
    3 => 'Experienced',
    5 => 'Specialist',
    8 => 'Expert',
    12 => 'Project Master',
    18 => 'Team Lead',
    25 => 'Project Wizard'
  }
  
  def add_points(amount, activity_type, description, related_object = nil)
    self.points += amount
    check_level_up
    
    # Record the activity
    activity = gamification_activities.create!(
      activity_type: activity_type,
      description: description,
      points: amount,
      related_object: related_object
    )
    
    # Check if any achievements were unlocked
    check_achievements
    
    save!
    activity
  end
  
  def current_rank
    RANKS.select { |level_req, _| level >= level_req }.max_by { |level_req, _| level_req }[1]
  end
  
  def points_to_next_level
    # Simple formula: 100 * current_level points needed for next level
    100 * level
  end
  
  def points_since_last_level
    # Points earned since reaching the current level
    if level == 1
      points
    else
      # Sum of points needed for previous levels
      total_points_for_previous_levels = (1...level).sum { |l| 100 * l }
      points - total_points_for_previous_levels
    end
  end
  
  def tasks_completed
    gamification_activities.where(activity_type: 'task_completed').count
  end
  
  def story_points_completed
    # Assuming you're storing story points in the metadata
    gamification_activities
      .where(activity_type: 'task_completed')
      .sum { |activity| activity.metadata['story_points'] || 0 }
  end
  
  def activities
    gamification_activities.order(created_at: :desc)
  end
  
  private
  
  def check_level_up
    next_level_points = points_to_next_level
    
    if points_since_last_level >= next_level_points
      self.level += 1
      # Create a level-up activity
      gamification_activities.build(
        activity_type: 'level_up',
        description: "Advanced to level #{level}",
        points: 0
      )
    end
  end

  def check_achievements
    Achievement.where.not(id: achievement_ids).find_each do |achievement|
      if achievement.criteria_met?(self)
        user_achievements.create!(achievement: achievement)
        
        # Create an achievement activity
        gamification_activities.create!(
          activity_type: 'achievement_earned',
          description: "Earned achievement \"#{achievement.name}\"",
          points: achievement.points,
          related_object: achievement
        )
        
        # Add achievement points
        self.points += achievement.points
      end
    end
  end
end
