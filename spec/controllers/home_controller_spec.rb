require 'spec_helper'

describe HomeController do
  describe "GET 'index'" do
    it "returns http success" do
      get :index
      response.should be_success
    end
  end

  describe "GET 'index' with authorization" do
    include_context 'user context'

    it "redirects to the tweet URL" do
      user = User.create_with_twitter_credentials(twitter_auth)
      get :index, {}, {user_id: user.id}
      response.should be_redirect
      response.should redirect_to(tweet_path)
    end
  end
end
