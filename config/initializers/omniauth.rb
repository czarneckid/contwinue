if Rails.env.development? || Rails.env.test?
  twitter_auth_hash = {
    provider: 'twitter', 
    uid: '1234',
    info: {
      name: 'David Czarnecki',
      nickname: 'CzarneckiD'
    },
    credentials: {
      token: 'token',
      secret: 'secret'
    }
  }

  OmniAuth.config.test_mode = true
  OmniAuth.config.add_mock(:twitter, twitter_auth_hash)
end

OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
end