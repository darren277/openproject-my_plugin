module WorkPackagesControllerPatch
  def self.included(base)
    base.class_eval do
      # Instead of overriding update method which doesn't exist,
      # hook into methods that do exist

      # For example, if you want to track when work packages are viewed
      alias_method :original_show, :show
      
      def show
        # Call the original method
        result = original_show
        
        # Add your gamification logic after a work package is viewed
        if work_package.present? && User.current.logged?
          add_view_points(work_package)
        end
        
        result
      end
      
      private
      
      def add_view_points(work_package)
        # Find or create the user's gamification profile
        profile = GamificationProfile.find_by(user_id: User.current.id)
        
        if profile.nil?
          profile = GamificationProfile.create!(user: User.current, points: 0, level: 1)
        end
        
        # You might want to add fewer points for just viewing
        # or implement logic to prevent farming points by repeated viewing
        profile.add_points(
          1,  # Just 1 point for viewing
          'work_package_viewed',
          "Viewed work package: #{work_package.subject}",
          work_package
        )
      rescue => e
        # Log error but don't interrupt the user's experience
        Rails.logger.error "Error awarding gamification points: #{e.message}"
      end
    end
  end
end
