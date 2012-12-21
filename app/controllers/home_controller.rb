class HomeController < ApplicationController
  require 'uri'
  def index

    if user_signed_in?

      twitter_authentication = current_user.twitter_authentication

      TweetStream.configure do |config|
        config.consumer_key = '9rgPKpQJil0ZaPgSVCeprw'
        config.consumer_secret = 'WB9tAjq11TDLXPKvpTjGF1PkemjzyNnIt1iG3nKSU'
        config.oauth_token = twitter_authentication.token
        config.oauth_token_secret = twitter_authentication.secret
        config.auth_method = :oauth
      end

      client = TweetStream::Client.new
        client.userstream do |status|
        puts "#{status.text}"
      end

    end
  end
end
