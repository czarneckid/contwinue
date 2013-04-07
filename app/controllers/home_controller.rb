class HomeController < ApplicationController
  def index
    redirect_to tweet_url if current_user
  end
end
