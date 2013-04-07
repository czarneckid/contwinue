require 'spec_helper'

describe Tweetable do
  include_context 'user context'

  describe '#tweet' do
    it 'should send an update to Twitter on behalf of the user' do
      user = User.create_with_twitter_credentials(twitter_auth)
      user.stub(:tweet).and_return('OK')
      user.should_receive(:tweet).with('This is my tweet', user.token, user.secret)
      user.tweet('This is my tweet', user.token, user.secret)
    end
  end
end