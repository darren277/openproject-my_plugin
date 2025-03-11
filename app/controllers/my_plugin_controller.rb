class MyPluginController < ApplicationController
  no_authorization_required! :index
  
  layout 'angular'

  def index
    #render plain: "My Plugin is working! This confirms the plugin is properly installed."
    render 'index'
  end
end
