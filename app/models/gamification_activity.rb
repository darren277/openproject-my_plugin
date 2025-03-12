class GamificationActivity < ApplicationRecord
  belongs_to :gamification_profile
  belongs_to :related_object, polymorphic: true, optional: true
  
  validates :activity_type, presence: true
  validates :description, presence: true
  validates :points, numericality: { only_integer: true }
  
  serialize :metadata, coder: JSON
  
  # Activity types
  TYPES = %w[
    task_completed 
    task_created
    review_completed
    bug_fixed
    sprint_completed
    level_up
    achievement_earned
  ]
  
  validates :activity_type, inclusion: { in: TYPES }
  
  # Icon mapping for activity types
  ICONS = {
    'task_completed' => '✅',
    'task_created' => '📝',
    'review_completed' => '🔄',
    'bug_fixed' => '🐛',
    'sprint_completed' => '🏁',
    'level_up' => '⬆️',
    'achievement_earned' => '🏅'
  }
  
  scope :recent, ->(limit) { order(created_at: :desc).limit(limit) }
  
  def icon
    ICONS[activity_type] || '📌'
  end
  
  def description_html
    case activity_type
    when 'task_completed'
      task_name = related_object&.subject || metadata['task_name'] || 'Unknown task'
      "Completed task <strong>\"#{task_name}\"</strong>"
    when 'achievement_earned'
      achievement_name = related_object&.name || metadata['achievement_name'] || 'Unknown achievement'
      "Earned achievement <strong>\"#{achievement_name}\"</strong>"
    else
      description
    end
  end
end
