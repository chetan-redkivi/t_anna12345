class HomeController < ApplicationController
  require 'uri'
  def index
    if user_signed_in?
      twitter_authentication = current_user.twitter_authentication
      @new_client = Twitter::Client.new(:oauth_token => twitter_authentication.token,:oauth_token_secret => twitter_authentication.secret)
      @tweets  = @new_client.user_timeline(twitter_authentication.uid.to_i,:count => 100)
      @filtered_tweet_url = []
      @tweets.each do |tweet|
        tweet_text = {}
        new_arr_urls = []
        if tweet.urls.size > 0
          tweet.urls.each do |url|
            new_arr_urls << url.expanded_url
          end
        end
        unless new_arr_urls.blank?
          tweet_text["url"] = new_arr_urls
        end
        unless tweet_text.blank?
          @filtered_tweet_url << tweet_text
        end
      end
    end
  end
end
