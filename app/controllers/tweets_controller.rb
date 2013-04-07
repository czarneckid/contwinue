class TweetsController < ApplicationController
  before_filter :require_logged_in_user

  def tweet
    if params[:tweet] && !params[:tweet].blank?
      @tweets, @status = Tweet.create_tweets(
        params[:tweet],
        continuation_style: current_user.continuation_style,
        continuation_text: current_user.continuation_text,
        continuation_placement: current_user.continuation_placement
      )

      @status = params[:preview].blank? ? @status : :preview
      case @status
      when :success
        @posted_tweets = current_user.tweet(@tweets, current_user.token, current_user.secret)
      when :preview
        @tweet = params[:tweet]
        @posted_tweets = Hash[ *@tweets.collect { |tweet| [ tweet, :preview ] }.flatten ]
      end
    end
  end
end
