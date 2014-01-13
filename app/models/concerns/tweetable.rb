module Tweetable
  def tweet(messages, access_token, access_token_secret)
    client = Twitter::REST::Client.new do |config|
      config.config.consumer_key = ENV['TWITTER_KEY'],
      config.consumer_secret = ENV['TWITTER_SECRET'],
      config.access_token = access_token,
      config.access_token_secret = access_token_secret
    end

    status = {}
    messages.each do |message|
      begin
        status[message] = client.update(message).id
      rescue
        status[message] = :failure
      end
    end

    status
  end
end