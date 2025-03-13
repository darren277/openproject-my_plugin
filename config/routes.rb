Rails.application.routes.draw do
  get '/my_plugin', to: 'my_plugin#index'

  # Gamification routes - non-project context
  scope 'gamification' do
    get '/', to: 'gamification#index', as: 'gamification'
    get 'profile/:id', to: 'gamification#show', as: 'gamification_profile'
    get 'profile', to: 'gamification#show', as: 'my_gamification_profile'
    get 'leaderboard', to: 'gamification#leaderboard', as: 'leaderboard'
    get 'achievements', to: 'gamification#achievements', as: 'achievements'
  end

  # Project-specific gamification routes
  scope 'projects/:project_id', as: 'project' do
    scope 'gamification' do
      get '/', to: 'gamification#index', as: 'gamification'
      # Add other project-specific gamification routes as needed
    end
  end

  # KPI dashboard routes - project context only
  get '/projects/:project_id/kpi_dashboard', to: 'kpi_dashboard#index', as: 'project_kpi_dashboard'
  get '/projects/:project_id/kpi_dashboard/data', to: 'kpi_dashboard#data', as: 'project_kpi_dashboard_data'
end
