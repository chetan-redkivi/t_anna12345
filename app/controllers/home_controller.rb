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
      #client = TweetStream::Client.new
      #  client.userstream do |status|
      #  puts "#{status.text}"
      #end
      @new_client = Twitter::Client.new(:oauth_token => twitter_authentication.token,:oauth_token_secret => twitter_authentication.secret)
      @tweets  = @new_client.user_timeline("shardulbhatt",:page =>1,:count => 100)
      a = @new_client.search("#", :lang => "en", :count => 100).results.size
      if @tweets.present?

        Rails.logger.info("================================>Information<=========================================")

        Rails.logger.info("================================>Name: #{@tweets.first.user.name} ")
        Rails.logger.info("================================>Joined Twitter on: #{@tweets.first.user.created_at.to_datetime} ")
        Rails.logger.info("================================>Location: #{@tweets.first.user.location} ")
        Rails.logger.info("================================>Timezone: #{@tweets.first.user.time_zone} ")
        Rails.logger.info("================================>Language: #{@tweets.first.user.lang} ")
        Rails.logger.info("================================>Bio: #{@tweets.first.user.description} ")
        Rails.logger.info("================================>URL: #{@tweets.first.user.url} ")

        Rails.logger.info("================================>Statistics<=========================================")
        @ratio = (@tweets.first.user.followers_count/@tweets.first.user.friends_count.to_f).round(2)
        Rails.logger.info("================================>Tweets: #{@tweets.first.user.statuses_count} ")
        Rails.logger.info("================================>Followers: #{@tweets.first.user.followers_count} ")
        Rails.logger.info("================================>Following: #{@tweets.first.user.friends_count} ")
        Rails.logger.info("================================>Followers ratio: #{@ratio} ")
        Rails.logger.info("================================>Listed: #{@tweets.first.user.listed_count} ")
      end
      @arr_hash = []
      @arr_mention = []
      @retweet_count = []
      @tweet_with_links = 0
      @tweet_with_hashtag = 0
      @tweet_with_mentions = 0
      @tweets.each do |tweet|
        @retweet_count << tweet.user.status.retweet_count.to_i
        if tweet.urls.present?
          @tweet_with_links = @tweet_with_links+1
        end

        if tweet.hashtags.present?
         @tweet_with_hashtag = @tweet_with_hashtag + 1
         tweet.text.split.select do |t|
           if t.start_with? '#'
            @arr_hash << t
           end
         end
        end

        if tweet.user_mentions.present?
          @tweet_with_mentions = @tweet_with_mentions + 1
          tweet.text.split.select do |t|
            if t.start_with? '@'
              @arr_mention << t
            end
          end

        end
      end

      Rails.logger.info("================================>Tweets Analysis<=========================================")
      Rails.logger.info("================================>Tweets with @mentions: #{@tweet_with_mentions}")
      Rails.logger.info("================================>Tweets with #hashtags: #{@tweet_with_hashtag}")
      Rails.logger.info("================================>Tweets with links: #{@tweet_with_links}")

      #render :text => @tweets.inspect and return false
      #@filtered_tweet_url = []
      #@tweets.each do |tweet|
      #  tweet_text = {}
      #  new_arr_urls = []
      #  if tweet.urls.present?
      #    #@tweet_with_links = @tweet_with_links+1
      #    tweet.urls.each do |url|
      #      new_arr_urls << url.expanded_url
      #    end
      #  end
      #  unless new_arr_urls.blank?
      #    tweet_text["url"] = new_arr_urls
      #  end
      #  unless tweet_text.blank?
      #    @filtered_tweet_url << tweet_text
      #  end
      #end

    end
  end
end
