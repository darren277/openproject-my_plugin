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

      # Account menu
      menu :account_menu,
             :my_profile,
             { controller: 'gamification', action: 'show' },
             caption: 'My Gamification',
             if: ->(*) { User.current.logged? }

      # Add permissions
      project_module :my_plugin do
        permission :view_my_plugin, { my_plugin: [:index] }, permissible_on: :project
        permission :view_kpi_dashboard, { kpi_dashboard: [:index, :data] }, permissible_on: :project
        permission :view_gamification, { gamification: [:index, :show] }, permissible_on: :project
      end

    end

    config.to_prepare do
      #WorkPackagesController.send(:include, WorkPackagesControllerPatch)
      WorkPackage.send(:include, WorkPackagePatch)
    end

    # Specify assets to precompile
    initializer 'openproject_my_plugin.assets' do |app|
      app.config.assets.precompile += %w(gamification.css)
    end
      
    # Add view paths for controllers
    initializer 'openproject_my_plugin.register_path' do |app|
      view_paths = Array(app.config.paths['app/views'])
      view_paths.unshift Engine.root.join('app', 'views')
    end
      
    # Add plugin translations
    initializer 'openproject_my_plugin.register_translations' do |app|
      app.config.i18n.load_path += Dir[Engine.root.join('config', 'locales', '*.{rb,yml}')]
    end
  end
end
