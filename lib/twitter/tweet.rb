require 'uri'
require 'typhoeus'

class Tweet
  class << self
    # Shorten URLs in a tweet using is.gd
    #
    # @param tweet [String] Tweet that may or may not contain any URLs
    #
    # @return Tweet where all URLs have been shortened
    def shorten_urls(tweet)
      return unless tweet

      uris = URI.extract(tweet)
      shortened_url_mapping = {}
      uris.each do |uri|
        shortened_url = Typhoeus::Request.get('http://is.gd/create.php', params: {
          format: 'simple',
          url: uri
        })

        if shortened_url.success?
          shortened_url_mapping[uri] = shortened_url.body
        end
      end

      shortened_url_mapping.each do |url, short_url|
        tweet = tweet.sub(url, short_url)
      end

      tweet
    end

    # Create a set of tweets from one long tweet
    #
    # @param long_tweet [String] Long tweet that may or may not be > 140 characters
    # @param continuation_style [Symbol, :text] Continuation style, :text or :numeric
    # @param continuation_text [String] Continuation text, e.g. (cont.)
    # @param continuation_placement [Symbol, :end] Whether to place the continuation at the beginning or the end of the tweet
    #
    # @return Array of tweets that have been created from the long tweet and status code, either :success or :error and a
    def create_tweets(long_tweet, continuation_style: :text, continuation_text: User::DEFAULT_CONTINUATION, continuation_placement: :end)
      return [], :success unless long_tweet

      case continuation_style
      when :text
        return create_tweets_text(long_tweet, continuation_text)
      when :numeric
        return create_tweets_numeric(long_tweet, continuation_placement: continuation_placement)
      end
    end

    private

    # Create a set of tweets using the numeric continuation style, e.g. (1/5)
    #
    # @param long_tweet [String] Long tweet that may or may not be > 140 characters
    # @param continuation_placement [Symbol, :end] Whether to place the continuation at the beginning or the end of the tweet
    #
    # @return Array of tweets that have been created from the long tweet and status code
    def create_tweets_numeric(long_tweet, continuation_placement: :end)
      total_tweets = long_tweet.size.fdiv(140).ceil.to_i
      continuation_adder = (total_tweets * " (#{total_tweets}/#{total_tweets})".length)
      total_tweets = (long_tweet.size + continuation_adder).fdiv(140).ceil.to_i
      words = long_tweet.strip.split(' ')
      tweets = []
      current_tweet = ''
      tweet_index = 1
      starting_tweet = true
      carry_over_word = nil

      words.each do |word|
        if word.length > 140
          return [], :error
        end

        continuation_text = "(#{tweet_index}/#{total_tweets})"
        if starting_tweet && continuation_placement == :beginning
          current_tweet << continuation_text + ' '
          if carry_over_word
            current_tweet << carry_over_word + ' '
            carry_over_word = nil
          end
          starting_tweet = false
        end

        if continuation_placement == :beginning
          if ((current_tweet.length + word.length + 1) < 140)
            current_tweet << word + ' '
          else
            tweets << current_tweet.strip
            current_tweet = ''
            starting_tweet = true
            carry_over_word = word
            tweet_index += 1
          end
        else
          if ((current_tweet.length + word.length + 1 + continuation_text.length) < 140)
            current_tweet << word + ' '
          else
            current_tweet << continuation_text
            tweets << current_tweet.strip
            current_tweet = word + ' '
            tweet_index += 1
          end
        end
      end

      if total_tweets > 1 && continuation_placement == :end
        tweets << current_tweet.strip + ' ' + "(#{tweet_index}/#{total_tweets})"
      else
        tweets << current_tweet.strip
      end

      shortened_tweets = []
      tweets.each do |tweet|
        shortened_tweets << shorten_urls(tweet)
      end

      return shortened_tweets, :success
    end

    # Create a set of tweets using the text continuation style, e.g. (cont.)
    #
    # @param long_tweet [String] Long tweet that may or may not be > 140 characters
    # @param continuation_text [String] Continuation text, e.g. (cont.)
    #
    # @return Array of tweets that have been created from the long tweet and status code
    def create_tweets_text(long_tweet, continuation_text = User::DEFAULT_CONTINUATION)
      words = long_tweet.strip.split(' ')

      tweets = []
      current_tweet = ''
      words.each do |word|
        if word.length > 140
          return [], :error
        end

        if ((current_tweet.length + word.length + 1 + continuation_text.length) < 140)
          current_tweet << word + ' '
        else
          current_tweet << continuation_text
          tweets << current_tweet
          current_tweet = word + ' '
        end
      end

      tweets << current_tweet.strip
      shortened_tweets = []
      tweets.each do |tweet|
        shortened_tweets << shorten_urls(tweet)
      end

      return shortened_tweets, :success
    end
  end
end