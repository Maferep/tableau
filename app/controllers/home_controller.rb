class HomeController < ApplicationController
  layout "container"
  allow_unauthenticated_access
  def index
    @images = Image.all
  end
end
