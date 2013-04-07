require 'spec_helper'

describe SessionsController do
  describe "POST 'create'" do
    it 'should create a session with :user_id set to the current_user id' do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:twitter]
      post :create, provider: 'twitter'
      session[:user_id].should_not be_nil
    end
  end

  describe "GET 'destroy'" do
    it "redirects to root_url" do
      get :destroy
      session[:user_id].should be_nil
      response.should be_redirect
      response.should redirect_to(root_url)
    end
  end
end
