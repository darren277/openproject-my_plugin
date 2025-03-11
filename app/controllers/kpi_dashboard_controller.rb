class KpiDashboardController < ApplicationController
  layout 'base'
  
  def index
    # This will render your Angular app
  end
  
  def data
    # Example endpoint to provide data to your Angular component
    kpis = {
      completed_tasks: WorkPackage.where(status: 'closed').count,
      story_points_completed: WorkPackage.sum(:story_points),
      # Add other metrics as needed
    }
    
    render json: kpis
  end
end
