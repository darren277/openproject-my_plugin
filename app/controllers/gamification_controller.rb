class GamificationController < ApplicationController
  layout 'base'
  
  def index
    # Show all users' gamification status
    @profiles = GamificationProfile.includes(:user).all
  end
  
  def show
    @profile = GamificationProfile.find_by(user_id: params[:user_id])
    
    if @profile.nil?
      flash[:error] = 'Profile not found'
      redirect_to action: 'index'
    end
  end
end
