require 'spec_helper'

describe PreferencesController do
  include_context 'user context'

  describe "GET 'show'" do
    it "should take you to your preferences page" do
      user = User.create_with_twitter_credentials(twitter_auth)

      get :show, {}, {user_id: user.id}
      response.should be_success
    end
  end

  describe "PUT 'update'" do
    it "should update your preferences" do
      user = User.create_with_twitter_credentials(twitter_auth)

      user.continuation_style.should == :text
      put :update, {continuation_style: :numeric}, {user_id: user.id}
      user.reload
      user.continuation_style.should == :numeric
      put :update, {continuation_style: :text}, {user_id: user.id}
      user.reload
      user.continuation_style.should == :text
      put :update, {continuation_style: :unknown}, {user_id: user.id}
      user.reload
      user.continuation_style.should == :text
      user.continuation_placement.should == :end
      put :update, {continuation_placement: :beginning}, {user_id: user.id}
      user.reload
      user.continuation_placement.should == :beginning
    end
  end
end
