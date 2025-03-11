Rails.application.routes.draw do
  get '/my_plugin', to: 'my_plugin#index'

  # KPI Dashboard routes
  get '/kpi_dashboard', to: 'kpi_dashboard#index'
  get '/kpi_dashboard/data', to: 'kpi_dashboard#data'
  
  # Gamification routes
  get '/gamification', to: 'gamification#index'
  get '/gamification/:user_id', to: 'gamification#show'
end
