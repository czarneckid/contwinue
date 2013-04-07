require 'spec_helper'

describe TweetsController do
  include_context 'user context'

  describe "POST 'tweet'" do
    it "should create a set of tweets for you" do
      user = User.create_with_twitter_credentials(twitter_auth)
      User.any_instance.stub(:tweet).and_return('OK')

      post :tweet, {tweet: 'This is a message on Twitter'}, {user_id: user.id}
      assigns(:tweets).size.should == 1
      response.should be_success
    end

    it "should not create a set of tweets if no tweet is supplied" do
      user = User.create_with_twitter_credentials(twitter_auth)

      post :tweet, {tweet: ''}, {user_id: user.id}
      assigns(:tweets).should be_nil
      assigns(:status).should be_nil
      assigns(:posted_tweets).should be_nil
      response.should be_success
    end

    it "should allow you to preview the tweets that will be posted" do
      user = User.create_with_twitter_credentials(twitter_auth)
      User.any_instance.stub(:tweet).and_return('OK')

      post :tweet, {tweet: 'This is a message on Twitter', preview: 'on'}, {user_id: user.id}
      assigns(:tweets).size.should == 1
      assigns(:status).should == :preview
      assigns(:tweet).should == 'This is a message on Twitter'
      response.should be_success
    end
  end
end
