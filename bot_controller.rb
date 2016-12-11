require 'twitter'

class BotController
  
  def initialize
    
    ## Bot user
    @user_screen_name = "TalkingBots"
    @user_id = 807035756665511936
    
    ## App config settings
    config = {
      consumer_key:        ENV['TALKING_BOTS_CONSUMER_KEY'],
      consumer_secret:     ENV['TALKING_BOTS_CONSUMER_SECRET'],
      access_token:        ENV['TALKING_BOTS_ACCESS_TOKEN'],
      access_token_secret: ENV['TALKING_BOTS_ACCESS_TOKEN_SECRET']
    }

    ## Get client
    @client = Twitter::REST::Client.new( config )

  end
  
  def tweet
    twitter_handles = [ "Bernie_ebooks", "TeaPartyBot", "RepElizaTuring", "RepHalTuring", "EveryTrumpDonor", "TheSeinfeldBot", "RobotGeorge3", "TrendingHx", "colombia_bot", "BillyJoel_Bot" ]
    twitter_handles.each { |t| process( t ) }
  end
  
  def process( twitter_handle )
    popular_tweets = popular_tweets( { twitter_handle:twitter_handle} )
    @client.retweet( popular_tweets.last.id ) if popular_tweets.any?    
  end
  
  def list

    twitter_handle = "EveryDemDonor"
    popular_tweets = popular_tweets( { twitter_handle:twitter_handle} )
    puts "#{twitter_handle}:" if popular_tweets.any?
    popular_tweets.each do |tweet|
      puts "From @#{tweet.user.screen_name} (#{tweet.favorite_count + tweet.retweet_count}): #{tweet.text}"
    end
    
  end
  
  def popular_tweets( opts )
    
    ## Set params
    twitter_handle = opts[:twitter_handle]
    threshold = opts[:threshold]
    
    threshold ||= 3
    results = []
    
    tweets = @client.search("@#{twitter_handle} exclude:retweets", result_type: "recent").take(100)

    tweets.each do |tweet|
      mentions = [] 
      tweet.user_mentions.each { |m| mentions << m.screen_name }
      next unless mentions.include?( twitter_handle )
      count = tweet.favorite_count + tweet.retweet_count
      if count >= threshold
        retweets = @client.retweets( tweet.id )
        previously_retweeted = false
        retweets.each do |rt|
          previously_retweeted = true if rt.user.id == @user_id
        end
        results << tweet unless previously_retweeted
      end
    end
    
    results
    
  end
 
  def pause
    sleep( rand(5)+5 )
  end

end