# This patch hooks into the WorkPackagesController to add gamification points
module WorkPackagesControllerPatch
  def self.included(base)
    base.class_eval do
      # Store the original method in a variable
      alias_method :original_update, :update
      alias_method :original_create, :create
      
      # Override the update method
      def update
        # Get the work package before update
        @work_package_before = WorkPackage.find(params[:id])
        original_status = @work_package_before.status_id
        
        # Call the original update method
        result = original_update
        
        # If update was successful and status changed to closed
        if result && @work_package.present? && @work_package.persisted?
          if original_status != @work_package.status_id && @work_package.closed?
            award_points_for_completion(@work_package)
          end
        end
        
        result
      end
      
      # Override the create method
      def create
        # Call the original create method
        result = original_create
        
        # If creation was successful
        if result && @work_package.present? && @work_package.persisted?
          # Award points for creating a task
          award_points_for_creation(@work_package)
        end
        
        result
      end
      
      private
      
      def award_points_for_completion(work_package)
        user = User.current
        profile = GamificationProfile.find_by(user_id: user.id)
        
        # Create profile if it doesn't exist
        if profile.nil?
          profile = GamificationProfile.create!(user: user, points: 0, level: 1)
        end
        
        # Points based on estimated hours or story points
        points = if work_package.story_points.present? && work_package.story_points > 0
                  work_package.story_points * 5  # 5 points per story point
                elsif work_package.estimated_hours.present? && work_package.estimated_hours > 0
                  work_package.estimated_hours.to_i * 2  # 2 points per estimated hour
                else
                  10  # Default points
                end
        
        # Add points and record the activity
        profile.add_points(
          points,
          'task_completed',
          "Completed work package: #{work_package.subject}",
          work_package
        )
      end
      
      def award_points_for_creation(work_package)
        user = User.current
        profile = GamificationProfile.find_by(user_id: user.id)
        
        # Create profile if it doesn't exist
        if profile.nil?
          profile = GamificationProfile.create!(user: user, points: 0, level: 1)
        end
        
        # Add points for task creation
        profile.add_points(
          3,  # Fixed points for creating a task
          'task_created',
          "Created work package: #{work_package.subject}",
          work_package
        )
      end
    end
  end
end
