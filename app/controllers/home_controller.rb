class HomeController < ApplicationController
  require 'uri'
  def index
    if user_signed_in?
      twitter_authentication = current_user.twitter_authentication
      @new_client = Twitter::Client.new(:oauth_token => twitter_authentication.token,:oauth_token_secret => twitter_authentication.secret)
      @tweets  = @new_client.user_timeline(twitter_authentication.uid.to_i,:count => 100)
      @filtered_tweets = []
      @tweets.each do |tweet|
        tweet_text = {}
        new_arr_urls = []
        arr_urls = URI.extract("#{tweet.text}")
        if arr_urls.size > 0
          arr_urls.each do |url|
            if url[0..10] == "http://t.co"
              if url[-1] == "."
                url = url.chomp('.')
              end
              new_arr_urls << url
            end
          end
        end
        unless new_arr_urls.blank?
          tweet_text["text"] = new_arr_urls
        end
        unless tweet_text.blank?
          @filtered_tweets << tweet_text
        end
      end

    end
  end
end
