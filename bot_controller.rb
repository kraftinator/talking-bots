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
  
  def process
    
    ## Bernie_ebooks
    popular_tweets = popular_tweets( { twitter_handle:"Bernie_ebooks"} )
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


=begin  
  def process
  
    ## @EveryDemDonor
    #popular_tweet_ids = popular_tweets( "EveryDemDonor", 4 )
    #@client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    #pause

    ## @EveryGOPDonor
    #popular_tweet_ids = popular_tweets( "EveryGOPDonor", 4 )
    #@client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    #pause

    ## @EveryTrumpDonor
    popular_tweet_ids = popular_tweets( "EveryTrumpDonor", 20 )
    begin
      @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    rescue Twitter::Error::Forbidden => error
      puts "[ERROR] Twitter::Error::Forbidden: #{ $! }"
      @client.retweet( popular_tweet_ids[1] ) if popular_tweet_ids.size > 1
    rescue
      puts "[ERROR] Unknown Error: #{ $! }"
    end
    pause
    
    ## @TheSeinfeldBot
    popular_tweet_ids = popular_tweets( "TheSeinfeldBot", 4 )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @TrendingHx
    popular_tweet_ids = popular_tweets( "TrendingHx", 4 )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause

    ## @TeaPartyBot
    popular_tweet_ids = popular_tweets( "TeaPartyBot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @Bernie_ebooks
    popular_tweet_ids = popular_tweets( "Bernie_ebooks" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @ConfederateBot
    #popular_tweet_ids = popular_tweets( "ConfederateBot" )
    #@client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    #pause
    
    ## @colombia_bot
    popular_tweet_ids = popular_tweets( "colombia_bot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @BillyJoel_Bot
    popular_tweet_ids = popular_tweets( "BillyJoel_Bot" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause

    ## @RepElizaTuring
    popular_tweet_ids = popular_tweets( "RepElizaTuring" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause

    ## @RepHalTuring
    popular_tweet_ids = popular_tweets( "RepHalTuring" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    pause
    
    ## @RobotGeorge3
    popular_tweet_ids = popular_tweets( "RobotGeorge3" )
    @client.retweet( popular_tweet_ids.first ) if popular_tweet_ids.any?
    
  end
=end  
  
 
  def pause
    sleep( rand(5)+5 )
  end

end