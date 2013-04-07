class SessionsController < ApplicationController
  def create
    credentials = request.env['omniauth.auth']
    user = User.where(uid: credentials.uid).first || User.create_with_twitter_credentials(credentials)
    session[:user_id] = user.id
    redirect_to tweet_url
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url
  end
end