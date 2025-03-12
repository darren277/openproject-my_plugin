module WorkPackagePatch
  def self.included(base)
    base.class_eval do
      after_update :award_gamification_points
      
      private
      
      def award_gamification_points
        return unless saved_change_to_status_id? && closed?
        return if User.current.nil? || !User.current.logged?
        
        profile = GamificationProfile.find_or_create_by(user: User.current)
        
        # Points based on estimated hours or story points
        points = if story_points.present? && story_points > 0
                  story_points * 5  # 5 points per story point
                elsif estimated_hours.present? && estimated_hours > 0
                  estimated_hours.to_i * 2  # 2 points per estimated hour
                else
                  10  # Default points
                end
        
        profile.add_points(
          points,
          'task_completed',
          "Completed work package: #{subject}",
          self
        )
      rescue => e
        Rails.logger.error "Error awarding gamification points: #{e.message}"
      end
    end
  end
end
