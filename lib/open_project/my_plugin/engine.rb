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
           caption: "My Plugin",
           after: :overview,
           param: :project_id

      # Project menu entry for KPI Dashboard
      menu :project_menu,
           :kpi_dashboard,
           { controller: 'kpi_dashboard', action: 'index' },
           caption: 'KPI Dashboard',
           after: :overview,
           param: :project_id
           
      # Top menu entry for Gamification
      menu :top_menu,
           :gamification,
           { controller: 'gamification', action: 'index' },
           caption: 'Gamification',
           if: ->(*) { User.current.logged? }

      # Add permissions
      project_module :my_plugin do
        permission :view_my_plugin, { my_plugin: [:index] }
        permission :view_kpi_dashboard, { kpi_dashboard: [:index, :data] }
        permission :view_gamification, { gamification: [:index, :show] }
      end

    end

    config.to_prepare do
      WorkPackagesController.send(:include, WorkPackagesControllerPatch)
    end
  end
end
