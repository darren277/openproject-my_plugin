class GamificationController < ApplicationController
  layout 'base'
  
  #before_action :require_login
  no_authorization_required! :index, :show, :leaderboard, :achievements
  
  def index
    @profiles = GamificationProfile.includes(:user)
                  .order('points DESC')
                  .paginate(page: params[:page], per_page: 20)
                  
    @top_achievers = GamificationProfile.order(points: :desc).limit(5)
    @recent_activities = GamificationActivity.includes(:gamification_profile => :user)
                          .order(created_at: :desc)
                          .limit(10)
    
    respond_to do |format|
      format.html
      format.json { render json: @profiles }
    end
  end
  
  def show
    user_id = params[:id] || User.current.id
    @user = User.find_by(id: user_id)
    
    if @user.nil?
      flash[:error] = t(:error_user_not_found)
      redirect_to action: 'index'
      return
    end
    
    @profile = GamificationProfile.find_by(user_id: user_id)
    
    if @profile.nil?
      # Create profile if it doesn't exist yet
      @profile = GamificationProfile.create!(
        user: @user,
        points: 0,
        level: 1
      )
    end
    
    @recent_achievements = @profile.achievements.order('user_achievements.created_at DESC').limit(4)
    @recent_activities = @profile.activities.recent(10)
    
    respond_to do |format|
      format.html
      format.json { render json: @profile.as_json(include: [:achievements, :activities]) }
    end
  end
  
  def leaderboard
    @period = params[:period] || 'all_time'
    
    case @period
    when 'weekly'
      start_date = Date.today.beginning_of_week
      @profiles = GamificationProfile.joins(:gamification_activities)
                    .where('gamification_activities.created_at >= ?', start_date)
                    .group('gamification_profiles.id')
                    .select('gamification_profiles.*, SUM(gamification_activities.points) as period_points')
                    .order('period_points DESC')
                    .limit(20)
    when 'monthly'
      start_date = Date.today.beginning_of_month
      @profiles = GamificationProfile.joins(:gamification_activities)
                    .where('gamification_activities.created_at >= ?', start_date)
                    .group('gamification_profiles.id')
                    .select('gamification_profiles.*, SUM(gamification_activities.points) as period_points')
                    .order('period_points DESC')
                    .limit(20)
    else # all_time
      @profiles = GamificationProfile.order(points: :desc).limit(20)
    end
    
    respond_to do |format|
      format.html
      format.json { render json: @profiles }
    end
  end
  
  def achievements
    @achievements = Achievement.all.order(points: :desc)
    
    if User.current.admin?
      render 'admin_achievements'
    else
      # For regular users, show which achievements they've earned
      @user_profile = GamificationProfile.find_by(user_id: User.current.id) || 
                      GamificationProfile.create!(user: User.current, points: 0, level: 1)
      @earned_achievements = @user_profile.achievements.pluck(:id)
    end
  end
end
