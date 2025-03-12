module MyPlugin
  class Hooks < OpenProject::Hook::ViewListener
    def work_package_closed(context = {})
      work_package = context[:work_package]
      user = context[:user]
      
      return unless work_package && user
      
      profile = GamificationProfile.find_or_create_by(user: user)
      
      # Award points based on story points or complexity
      points_to_award = work_package.story_points || 1
      profile.add_points(points_to_award)
    end
  end
end
