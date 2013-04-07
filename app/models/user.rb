class User
  include Mongoid::Document
  include Tweetable

  DEFAULT_CONTINUATION = 'cont.'

  field :uid, type: String
  field :name, type: String
  field :nickname, type: String
  field :token, type: String
  field :secret, type: String
  field :continuation_style, type: Symbol, default: :text
  field :continuation_text, type: String, default: DEFAULT_CONTINUATION
  field :continuation_placement, type: Symbol, default: :end

  index({ uid: 1 }, { unique: true })

  def self.create_with_twitter_credentials(twitter_credentials)
    create! do |user|
      user.uid = twitter_credentials.uid
      user.name = twitter_credentials.info.name
      user.nickname = twitter_credentials.info.nickname
      user.token = twitter_credentials.credentials.token
      user.secret = twitter_credentials.credentials.secret
    end
  end
end
