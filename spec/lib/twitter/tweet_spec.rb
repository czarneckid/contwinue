require 'spec_helper'

describe Tweet do
  let(:long_tweet) { %(Leggings forage officia cosby sweater cred PBR seitan, sriracha hella DIY american apparel fingerstache echo park gluten-free. Wayfarers portland mlkshk, food truck flexitarian accusamus placeat 8-bit. Literally mustache esse, nostrud scenester tattooed tumblr blog. Butcher 90's wolf accusamus hashtag irure. Exercitation pinterest pop-up tonx single-origin coffee, pug pariatur synth sustainable aliquip commodo sapiente DIY aute squid. Pour-over dreamcatcher narwhal in, lomo tousled american apparel selvage art party neutra shoreditch bushwick. Reprehenderit fixie mlkshk portland, non mcsweeney's sed Austin echo park swag.) }
  let(:single_word_141_characters) { %(888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888888) }
  let(:long_url) { %(http://maps.google.co.uk/maps?f=q&source=s_q&hl=en&geocode=&q=louth&sll=53.800651,-4.064941&sspn=33.219383,38.803711&ie=UTF8&hq=&hnear=Louth,+United+Kingdom&ll=53.370272,-0.004034&spn=0.064883,0.075788&z=14) }
  let(:long_tweet_for_numeric_continuation_style) { %(Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nam ultricies ultrices massa, ut fringilla velit tempus non. Aenean ut metus ut augue ornare eleifend sed a purus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Vivamus tincidunt, ligula ac elementum condimentum, odio quam laoreet diam, vitae auctor nunc risus et arcu. Nullam massa metus, elementum quis eleifend ut, mattis vel nisi. Duis vel erat odio. Quisque erat ante, faucibus in imperdiet quis, porta id sapien. Vivamus cras amet.) }

  describe '.create_tweets' do
    describe 'continuation_style = :text' do
      it 'should create a set of tweets for one long tweet' do
        tweets, status = Tweet.create_tweets(long_tweet)
        tweets.size.should == 5
        tweets.each do |tweet|
          tweet.length.should be < 140
        end
        status.should == :success
      end

      it 'should create a single tweet for a tweet < 140 charactets' do
        tweets, status = Tweet.create_tweets('This is not a long tweet')
        tweets.size.should == 1
        (tweets[0] =~ /#{User::DEFAULT_CONTINUATION}/).should be_false
      end

      it 'should return a status of :error if any word is > 140 characters' do
        tweets, status = Tweet.create_tweets(single_word_141_characters)
        tweets.should == []
        status.should == :error
      end

      it 'should create a set of tweets with shortened URLs if URLs are present in the original tweet' do
        VCR.use_cassette('single_shortened_url', record: :once) do
          tweets, status = Tweet.create_tweets('This is a tweet with a URL to http://www.google.com and also another URL to http://www.google.com. It will be really really long so we should probably plan on it spanning over another tweet.')
          tweets.size.should == 2
          (tweets[0] =~ /google.com/).should be_false
          (tweets[1] =~ /google.com/).should be_false
          (tweets[0] =~ /is.gd/).should be_true
        end
      end
    end

    describe 'continuation_style = :numeric' do
      it 'should create a set of tweets for one long tweet' do
        tweets, status = Tweet.create_tweets(long_tweet, continuation_style: :numeric)
        tweets.size.should == 5
        tweets.each.with_index(1) do |tweet, index|
          tweet.length.should be < 140
          (tweet =~ /\d\/\d/).should be_true
        end
        status.should == :success

        tweets, status = Tweet.create_tweets(long_tweet_for_numeric_continuation_style, continuation_style: :numeric)
        tweets.size.should == 5
        tweets.each.with_index(1) do |tweet, index|
          tweet.length.should be < 140
          (tweet =~ /\d\/\d/).should be_true
        end
        status.should == :success
      end

      it 'should create a set of tweets for one long tweet and place the continuation at the beginning' do
        tweets, status = Tweet.create_tweets(long_tweet, continuation_style: :numeric, continuation_placement: :beginning)
        tweets.size.should == 5
        tweets.each.with_index(1) do |tweet, index|
          tweet.length.should be < 140
          (tweet =~ /^\(\d\/\d\)/).should be_true
        end
        status.should == :success
      end

      it 'should create a single tweet for a tweet < 140 charactets' do
        tweets, status = Tweet.create_tweets('This is not a long tweet', continuation_style: :numeric)
        tweets.size.should == 1
        (tweets[0] =~ /\d\/\d/).should be_false
      end

      it 'should return a status of :error if any word is > 140 characters' do
        tweets, status = Tweet.create_tweets(single_word_141_characters, continuation_style: :numeric)
        tweets.should == []
        status.should == :error
      end

      it 'should create a set of tweets with shortened URLs if URLs are present in the original tweet' do
        VCR.use_cassette('single_shortened_url', record: :once) do
          tweets, status = Tweet.create_tweets('This is a tweet with a URL to http://www.google.com and also another URL to http://www.google.com. It will be really really long so we should probably plan on it spanning over another tweet.', continuation_style: :numeric)
          tweets.size.should == 2
          (tweets[0] =~ /google.com/).should be_false
          (tweets[1] =~ /google.com/).should be_false
          (tweets[0] =~ /is.gd/).should be_true
        end
      end
    end
  end

  describe '.shorten_urls' do
    it 'should return the same text if no URLs are present' do
      tweet = Tweet.shorten_urls('this is a tweet with no URLs')
      tweet.should == 'this is a tweet with no URLs'
    end

    it 'should return shortened URLs if URLs are present' do
      VCR.use_cassette('single_shortened_url', record: :once) do
        tweet = Tweet.shorten_urls('this is a tweet with http://www.google.com present in the tweet')
        (tweet =~ /google.com/).should be_false
        (tweet =~ /is.gd/).should be_true
      end
    end
  end
end