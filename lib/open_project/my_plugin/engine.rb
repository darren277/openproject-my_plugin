require 'active_support/dependencies'
require 'open_project/plugins'

module OpenProject::MyPlugin
  class Engine < ::Rails::Engine
    engine_name :openproject_my_plugin

    include OpenProject::Plugins::ActsAsOpEngine

    register(
      'openproject-my_plugin',
      author_url: 'https://github.com/darren277',
      requires_openproject: '>= 13.1.0'
    ) do
      # Add a simple menu item to the top menu
      menu :top_menu,
           :my_plugin,
           { url: '/my_plugin' },  # Use URL instead of controller/action
           caption: "My Plugin"
    end
  end
end
