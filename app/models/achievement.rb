class Achievement < ApplicationRecord
  has_many :user_achievements, dependent: :destroy
  has_many :gamification_profiles, through: :user_achievements
  
  validates :name, presence: true
  validates :description, presence: true
  validates :icon, presence: true
  validates :points, numericality: { only_integer: true, greater_than: 0 }
  
  serialize :criteria, Hash
  
  def criteria_met?(profile)
    case criteria['type']
    when 'tasks_completed'
      profile.tasks_completed >= criteria['count'].to_i
    when 'story_points'
      profile.story_points_completed >= criteria['count'].to_i
    when 'specific_task'
      # Check if specific task(s) were completed
      task_ids = criteria['task_ids'] || []
      profile.gamification_activities
             .where(activity_type: 'task_completed')
             .where(related_object_id: task_ids)
             .count >= task_ids.size
    else
      false
    end
  end
end
