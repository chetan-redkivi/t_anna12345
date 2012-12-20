class HomeController < ApplicationController
  require 'uri'
  def index


    if user_signed_in?
      twitter_authentication = current_user.twitter_authentication
      @new_client = Twitter::Client.new(:oauth_token => twitter_authentication.token,:oauth_token_secret => twitter_authentication.secret)
      @tweets  = @new_client.user_timeline(twitter_authentication.uid.to_i,:page =>1,:count => 100)
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

        Rails.logger.info("================================>Tweets: #{@tweets.first.user.statuses_count} ")
        Rails.logger.info("================================>Followers: #{@tweets.first.user.followers_count} ")
        Rails.logger.info("================================>Following: #{@tweets.first.user.friends_count} ")
        Rails.logger.info("================================>Followers ratio: #{@ratio} ")
        Rails.logger.info("================================>Listed: #{@tweets.first.user.listed_count} ")
        @ratio = (@tweets.first.user.followers_count/@tweets.first.user.friends_count.to_f).round(2)
      end
      @arr_hash = []
      @arr_mention = []
      @retweet_count = 0
      @tweet_with_links = 0
      @tweet_with_hashtag = 0
      @tweet_with_mentions = 0
      @tweet_with_media = 0
      @reply_count = 0
      @tweets.each do |tweet|


        if tweet.in_reply_to_status_id.present?
          @reply_count = @reply_count + 1
        end


        if tweet.retweeted_status.present?
           @retweet_count = @retweet_count + 1
        end

        if tweet.user_mentions.present?
          @tweet_with_mentions = @tweet_with_mentions + 1
          tweet.text.split.select do |t|
            if t.start_with? '@'
              @arr_mention << t
            end
          end
        end

        if tweet.hashtags.present?
         @tweet_with_hashtag = @tweet_with_hashtag + 1
         tweet.text.split.select do |t|
           if t.start_with? '#'
            @arr_hash << t
           end
         end
        end

        if tweet.urls.present?
          @tweet_with_links = @tweet_with_links+1
        end

        if tweet.media.present?
          @tweet_with_media = @tweet_with_media+1
        end
      end

      Rails.logger.info("================================>Tweets Analysis<=========================================")
      Rails.logger.info("================================>Tweets with @mentions: #{@tweet_with_mentions}")
      Rails.logger.info("================================>Tweets with @mentions: #{@tweet_with_mentions}")
      Rails.logger.info("================================>Retweets: #{@retweet_count}")
      Rails.logger.info("================================>Tweets with links: #{@tweet_with_links}")
    end
  end
end
