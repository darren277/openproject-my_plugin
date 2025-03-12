namespace :my_plugin do
  desc "Precompile assets for my_plugin only"
  task :precompile_assets do
    # Set up Rails environment
    require File.expand_path('../../../config/environment', __dir__)
    
    # Only compile assets from your plugin
    Rails.application.config.assets.precompile += %w(
      gamification.css
      kpi_dashboard.css
    )
    
    # Limit the precompile paths to just your plugin
    original_paths = Rails.application.config.assets.paths.dup
    plugin_path = File.expand_path('../../..', __dir__)
    asset_paths = original_paths.select { |p| p.start_with?(plugin_path) }
    Rails.application.config.assets.paths = asset_paths
    
    # Run the precompile task
    Rake::Task["assets:precompile"].invoke
    
    # Restore original paths
    Rails.application.config.assets.paths = original_paths
  end
end
