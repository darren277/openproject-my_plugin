namespace :openproject_my_plugin do
  desc "Precompile assets for my_plugin only"
  task :precompile_assets => :environment do
    # Define which assets from your plugin should be precompiled
    plugin_assets = %w(
      gamification.css
      kpi_dashboard.css
    )
    
    # Get the plugin's path
    plugin_path = Gem::Specification.find_by_name("openproject-my_plugin").gem_dir rescue File.expand_path("../../..", __FILE__)
    
    # Tell Rails to precompile only our assets
    Rails.application.config.assets.precompile += plugin_assets
    
    # Store original paths
    original_paths = Rails.application.config.assets.paths.dup
    
    begin
      # Limit paths to just the plugin
      asset_paths = original_paths.select { |p| p.start_with?(plugin_path) }
      Rails.application.config.assets.paths = asset_paths unless asset_paths.empty?
      
      # Run the precompile task
      Rake::Task["assets:precompile"].invoke
      puts "Assets for openproject_my_plugin precompiled successfully"
    ensure
      # Restore original paths
      Rails.application.config.assets.paths = original_paths
    end
  end
end
