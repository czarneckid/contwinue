module Tweetable
  def tweet(messages, oauth_token, oauth_token_secret)
    client = Twitter::Client.new(
      oauth_token: oauth_token,
      oauth_token_secret: oauth_token_secret
    )

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