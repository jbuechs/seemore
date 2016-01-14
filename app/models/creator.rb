
class Creator < ActiveRecord::Base
  has_many :content
  has_and_belongs_to_many :users
  validates :p_id, :provider, :username, presence: true

  include HTTParty
  LIMIT_PER_PAGE = 10

  #method to configure twitter
  def twit
    Seemore::Application.config.twitter
  end

  def has_image?
    if avatar_url.nil?
      false
    else
      true
    end
  end

#calls methods for each provider
  def get_content
    if provider == "twitter"
      get_tweets
    elsif provider == "vimeo"
      get_videos
    else
      raise "Content provider provided is not recognized (vimeo, twitter)."
    end
    self.last_updated = DateTime.now
    self.save
  end

#method to call api for tweets and save to database
#this code could by DRYer but between twitter and vimeo it would require at least 4 methods. TODO: separate these in the least confusing way
  def get_tweets
    tweet_array = twit.user_timeline(self.username)
    tweets = []
    tweet_array.each do |tweet|
      #checks to see if that content already exists in the database
      content = Content.find_by(content_id: tweet.id.to_s)
      #creates new content if it does not exist
      if content.nil?
        tweets << Content.create(
        content_id: tweet.id.to_s,
        text: tweet.text,
        create_time: DateTime.parse(tweet.created_at.to_s),
        favorites: tweet.favorited?,
        retweet_count: tweet.retweet_count,
        creator_id: self.id,
        provider: "twitter"
        )
      end
    end
  end

  def get_videos
    response = HTTParty.get("https://api.vimeo.com/users/#{self.p_id}/videos?per_page=#{LIMIT_PER_PAGE}", headers: {"Authorization" => "bearer #{ENV['VIMEO_ACCESS_TOKEN']}"})
    parsed_response = JSON.parse(response)
    vids = parsed_response["data"]
    videos = []
    vids.each do |vid|
      #checks to see if content already exists
      content = Content.find_by(content_id: vid["uri"].gsub(/[^\d]/, ''))
      #if it doesn't exist, create new content with the vimeo data
      if content.nil?
        videos << Content.create(
          content_id: vid["uri"].gsub(/[^\d]/, ''),
          text: vid["description"],
          create_time: DateTime.parse(vid["created_time"].to_s),
          favorites: vid["metadata"]["connections"]["likes"]["total"],
          creator_id: self.id,
          provider: "vimeo"
        )
      end
    end
  end
end
