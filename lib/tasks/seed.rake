namespace :openproject_my_plugin do
  desc "Seeds the plugin with initial data"
  task seed: :environment do
    # Load your achievements seed file
    load File.join(Gem.loaded_specs['openproject-my_plugin'].full_gem_path, 'db', 'seeds', 'achievements.rb')
    
    # Add more seed files if needed
  end
end
