class KpiDashboardController < ApplicationController
  before_action :find_project_by_project_id
  
  #before_action :authorize
  # TEMPORARY NO AUTH:
  no_authorization_required! :index, :data
  Rails.logger.warn "KpiDashboardController uses no authorization right now"
  
  layout 'base'
  
  def index
    # This will render the view with the dashboard UI
    Rails.logger.debug "KPI Dashboard: Project ID=#{@project.id}, User=#{User.current.name}"
    #Rails.logger.info "User has permission: #{User.current.allowed_to?(:view_kpi_dashboard, @project)}"
    Rails.logger.debug "User: #{User}"
  end
  
  def data
    # Get time period from params (default to 30 days)
    days = (params[:days] || 30).to_i
    start_date = Date.today - days.days
    
    # Get work packages for this project within the time range
    work_packages = @project.work_packages
                     .where('created_at >= ? OR updated_at >= ?', start_date, start_date)
    
    completed_work_packages = work_packages.where(status_id: Status.closed_id)
    
    # Calculate summary metrics
    total_tasks = work_packages.count
    completed_tasks = completed_work_packages.count
    completion_rate = total_tasks > 0 ? ((completed_tasks.to_f / total_tasks) * 100).round(1) : 0
    
    # Calculate average completion time (in days)
    avg_completion_time = calculate_avg_completion_time(completed_work_packages)
    
    # Generate data for trend chart (tasks created vs completed by day)
    completion_trend = generate_completion_trend(work_packages, start_date)
    
    # Generate status distribution data
    status_distribution = generate_status_distribution(work_packages)
    
    # Generate team performance data
    team_performance = generate_team_performance(work_packages)
    
    # Generate story points chart data
    story_points = generate_story_points_data(work_packages, start_date)
    
    # Get recent activity
    recent_activity = generate_recent_activity(work_packages)
    
    # Return data as JSON
    render json: {
      summary: {
        total_tasks: total_tasks,
        completed_tasks: completed_tasks,
        completion_rate: completion_rate,
        avg_completion_time: avg_completion_time
      },
      completion_trend: completion_trend,
      status_distribution: status_distribution,
      team_performance: team_performance,
      story_points: story_points,
      recent_activity: recent_activity
    }
  end
  
  private
  
  def calculate_avg_completion_time(work_packages)
    # For simplicity, we'll use the difference between created_at and updated_at for closed work packages
    # In a real implementation, you might want to use status change timestamps
    total_days = 0
    count = 0
    
    work_packages.each do |wp|
      if wp.closed? && wp.created_at.present?
        # Use either closed_at or updated_at
        closed_at = wp.respond_to?(:closed_at) ? wp.closed_at : wp.updated_at
        days = (closed_at.to_date - wp.created_at.to_date).to_i
        
        total_days += days
        count += 1
      end
    end
    
    count > 0 ? (total_days.to_f / count).round(1) : 0
  end
  
  def generate_completion_trend(work_packages, start_date)
    # Generate date range
    date_range = (start_date..Date.today).to_a
    
    # Initialize data structure with zeros
    trend_data = date_range.map do |date|
      {
        date: date.strftime('%Y-%m-%d'),
        created: 0,
        completed: 0
      }
    end
    
    # Count created work packages by date
    work_packages.each do |wp|
      created_date = wp.created_at.to_date
      if created_date >= start_date
        index = (created_date - start_date).to_i
        trend_data[index][:created] += 1 if index >= 0 && index < trend_data.length
      end
      
      # Count completed work packages by date
      if wp.closed?
        closed_date = wp.updated_at.to_date
        if closed_date >= start_date
          index = (closed_date - start_date).to_i
          trend_data[index][:completed] += 1 if index >= 0 && index < trend_data.length
        end
      end
    end
    
    trend_data
  end
  
  def generate_status_distribution(work_packages)
    # Group work packages by status
    status_counts = work_packages.group(:status_id).count
    
    # Get status names
    statuses = Status.where(id: status_counts.keys).pluck(:id, :name).to_h
    
    # Format data for chart
    status_counts.map do |status_id, count|
      {
        status: statuses[status_id] || "Unknown",
        count: count
      }
    end
  end
  
  def generate_team_performance(work_packages)
    # Group completed work packages by assignee
    assignee_performance = {}
    
    work_packages.each do |wp|
      next if wp.assigned_to_id.nil?
      
      assignee_id = wp.assigned_to_id
      assignee_name = wp.assigned_to.name
      
      assignee_performance[assignee_id] ||= {
        name: assignee_name,
        assigned: 0,
        completed: 0,
        story_points: 0
      }
      
      assignee_performance[assignee_id][:assigned] += 1
      assignee_performance[assignee_id][:completed] += 1 if wp.closed?
      
      # Sum story points if available
      if wp.respond_to?(:story_points) && wp.story_points.present?
        assignee_performance[assignee_id][:story_points] += wp.story_points
      end
    end
    
    # Convert to array and calculate completion rate
    assignee_performance.values.map do |perf|
      completion_rate = perf[:assigned] > 0 ? ((perf[:completed].to_f / perf[:assigned]) * 100).round(1) : 0
      perf.merge(completion_rate: completion_rate)
    end
  end
  
  def generate_story_points_data(work_packages, start_date)
    # If the project doesn't use story points, return empty data
    return [] unless WorkPackage.column_names.include?('story_points') || work_packages.first&.respond_to?(:story_points)
    
    # Generate weekly data for story points
    weekly_data = []
    current_date = start_date
    
    while current_date <= Date.today
      week_end = [current_date + 6.days, Date.today].min
      
      # Get work packages completed this week
      weekly_completed = work_packages.where(status_id: Status.closed_id)
                                     .where('updated_at >= ? AND updated_at <= ?', 
                                            current_date.beginning_of_day, 
                                            week_end.end_of_day)
      
      # Sum story points
      story_points = weekly_completed.sum(:story_points)
      
      weekly_data << {
        week: "#{current_date.strftime('%b %d')} - #{week_end.strftime('%b %d')}",
        story_points: story_points
      }
      
      current_date = week_end + 1.day
    end
    
    weekly_data
  end
  
  def generate_recent_activity(work_packages)
    # Get most recently updated work packages
    recent = work_packages.order(updated_at: :desc).limit(10)
    
    recent.map do |wp|
      {
        id: wp.id,
        subject: wp.subject,
        type: wp.type.try(:name) || "Task",
        status: wp.status.try(:name) || "Unknown",
        assignee: wp.assigned_to.try(:name),
        date: wp.updated_at,
        story_points: wp.respond_to?(:story_points) ? wp.story_points : nil
      }
    end
  end
end
