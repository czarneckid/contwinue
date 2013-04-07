require 'spec_helper'

describe User do
  include_context 'user context'

  describe 'defaults' do
    it 'should have default set of preferences' do
      user = User.create_with_twitter_credentials(twitter_auth)
      user.continuation_style.should == :text
      user.continuation_text.should == User::DEFAULT_CONTINUATION
      user.continuation_placement.should == :end
    end
  end

  describe '.create_with_twitter_credentials' do
    it 'should create a user from the Twitter credentials' do
      user = User.create_with_twitter_credentials(twitter_auth)
      User.count.should == 1
      user.uid.should == '12345'
      user.nickname.should == 'CzarneckiD'
    end
  end
end
