# db/seeds/achievements.rb

# Only seed if no achievements exist yet
if Achievement.count == 0
  puts "Creating default achievements..."
  
  # Task completion achievements
  Achievement.create!(
    name: "Task Master",
    description: "Complete 25 tasks",
    icon: "✅",
    points: 50,
    criteria: {
      type: 'tasks_completed',
      count: 25
    }
  )
  
  Achievement.create!(
    name: "Super Tasker",
    description: "Complete 100 tasks",
    icon: "🔥",
    points: 150,
    criteria: {
      type: 'tasks_completed',
      count: 100
    }
  )
  
  # Story point achievements
  Achievement.create!(
    name: "Point Collector",
    description: "Earn 100 story points",
    icon: "📊",
    points: 75,
    criteria: {
      type: 'story_points',
      count: 100
    }
  )
  
  Achievement.create!(
    name: "Story Master",
    description: "Earn 500 story points",
    icon: "📈",
    points: 200,
    criteria: {
      type: 'story_points',
      count: 500
    }
  )
  
  # Sprint-related achievements
  Achievement.create!(
    name: "Sprint Champion",
    description: "Complete all assigned tasks in a sprint",
    icon: "🏆",
    points: 100,
    criteria: {
      type: 'sprint_completed',
      count: 1
    }
  )
  
  # Quick resolver achievement
  Achievement.create!(
    name: "Quick Resolver",
    description: "Resolve 5 issues in a single day",
    icon: "⚡",
    points: 125,
    criteria: {
      type: 'quick_resolver',
      count: 5
    }
  )
  
  # Bug hunter achievements
  Achievement.create!(
    name: "Bug Hunter",
    description: "Find and fix 10 critical bugs",
    icon: "🔍",
    points: 100,
    criteria: {
      type: 'bug_fixed',
      count: 10
    }
  )
  
  # Feature implementation achievements
  Achievement.create!(
    name: "Feature Master",
    description: "Successfully implement a major feature",
    icon: "🚀",
    points: 150,
    criteria: {
      type: 'feature_implemented',
      count: 1
    }
  )
  
  # Team collaboration achievements
  Achievement.create!(
    name: "Team Player",
    description: "Review 10 pull requests",
    icon: "👥",
    points: 75,
    criteria: {
      type: 'reviews_completed',
      count: 10
    }
  )
  
  Achievement.create!(
    name: "Mentor",
    description: "Help 5 team members complete tasks",
    icon: "🧠",
    points: 100,
    criteria: {
      type: 'helped_others',
      count: 5
    }
  )
  
  # Time-based achievements
  Achievement.create!(
    name: "Early Bird",
    description: "Complete a task before the deadline",
    icon: "⏰",
    points: 50,
    criteria: {
      type: 'early_completion',
      count: 1
    }
  )
  
  Achievement.create!(
    name: "Streak Master",
    description: "Complete tasks on 5 consecutive days",
    icon: "📆",
    points: 125,
    criteria: {
      type: 'consecutive_days',
      count: 5
    }
  )
  
  # Special achievements
  Achievement.create!(
    name: "First Steps",
    description: "Complete your first task",
    icon: "👣",
    points: 25,
    criteria: {
      type: 'tasks_completed',
      count: 1
    }
  )
  
  Achievement.create!(
    name: "Milestone Master",
    description: "Complete a milestone on time",
    icon: "🏁",
    points: 200,
    criteria: {
      type: 'milestone_completed',
      count: 1
    }
  )
  
  puts "Created #{Achievement.count} achievements"
end
