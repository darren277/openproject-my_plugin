namespace :openproject_my_plugin do
  desc "Seeds the plugin with initial data"
  task seed: :environment do
    # Get the plugin root path
    plugin_root = File.expand_path('../../..', __FILE__)
    
    # Load seed file
    seed_file = File.join(plugin_root, 'db', 'seeds', 'achievements.rb')
    
    if File.exist?(seed_file)
      puts "Seeding achievements from #{seed_file}"
      load seed_file
    else
      puts "Seed file not found: #{seed_file}"
    end
  end
end
