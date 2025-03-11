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
           { controller: '/my_plugin/my_plugin', action: 'index'},
           caption: "My Plugin Frontend"
      
      # Uncomment this section if you want to add project-specific features
      # project_module :my_plugin_module do
      #   permission :view_my_plugin,
      #              {
      #                 my_plugin: %i[index show],
      #              },
      #              permissible_on: [:project]
      #
      #   permission :manage_my_plugin,
      #              {
      #                 my_plugin: %i[new create edit update destroy],
      #              },
      #              permissible_on: [:project]
      # end
      #
      # menu :project_menu,
      #      :my_plugin,
      #      { controller: 'my_plugin', action: 'index' },
      #      caption: "My Plugin",
      #      after: :overview,
      #      param: :project_id,
      #      icon: 'icon2 icon-star'
    end

    initializer 'my_plugin.register_routes' do
      Rails.application.routes.draw do
        #get 'my_plugin', to: 'my_plugin#index'
	mount OpenProject::MyPlugin::Engine, at: '/my_plugin'
      end
    end
    
    # Uncomment if you want to add a block to the homescreen
    # config.after_initialize do
    #   OpenProject::Static::Homescreen.manage :blocks do |blocks|
    #     blocks.push(
    #       { partial: 'homescreen_block', if: Proc.new { true } }
    #     )
    #   end
    # end
    
    # Example of subscribing to OpenProject notifications
    # config.after_initialize do
    #   OpenProject::Notifications.subscribe 'user_invited' do |token|
    #     user = token.user
    #     Rails.logger.debug "#{user.mail} invited to OpenProject"
    #   end
    # end

    # List any assets your plugin needs to include
    # assets %w(my_plugin_icon.png)
  end
end
