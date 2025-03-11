class MyPluginController < ApplicationController
  no_authorization_required! :index
  
  layout 'admin'
  
  def index
    render 'index'
  end
end
