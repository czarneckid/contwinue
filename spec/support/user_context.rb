shared_context "user context" do
  let(:twitter_credentials) { TwitterCredentials.new('token', 'secret') }
  let(:twitter_info) { TwitterInfo.new('David Czarnecki', 'CzarneckiD') }
  let(:twitter_auth) { TwitterAuth.new('12345', twitter_info, twitter_credentials) }
end