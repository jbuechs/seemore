require 'pry'

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

  def get_content
    if provider == "twitter"
      get_tweets
    elsif provider == "vimeo"
      get_videos
    else
      raise "Content provider provided is not recognized (vimeo, twitter)."
    end
  end

  def get_tweets
    tweet_array = twit.user_timeline(self.username)
    tweets = []
    tweet_array.each do |tweet|
      content = Content.find_by(content_id: tweet.id.to_s)
      if !content.nil?
        tweets.push(content)
      else
        tweets << Content.create(
        content_id: tweet.id.to_s,
        text: tweet.text,
        create_time: tweet.created_at,
        favorites: tweet.favorited?,
        retweet_count: tweet.retweet_count,
        creator_id: self.id,
        provider: "twitter"
        )
      end
    end
    return tweets
  end

  # def get_saved_content
  #   contents = []
  #   self.content.each do |cont|
  #     contents.push(cont)
  #   end
  #   return contents
  # end

  # def update_content
  #   creators = self.creators
  #   creators.each do |creator|
  #     if creator.provider == "twitter"
  #       @tweets = twitter.user_timeline(creator.username)
  #       @tweets.each do |tweet|
  #         tweet.find_or_create
  #       end
  #     else
  #       #TODO: same for vimeo
  #     end
  #   end
  # end

  def get_videos
    response = HTTParty.get("https://api.vimeo.com/users/#{self.p_id}/videos?per_page=#{LIMIT_PER_PAGE}", headers: {"Authorization" => "bearer #{ENV['VIMEO_ACCESS_TOKEN']}"})
    parsed_response = JSON.parse(response)
    vids = parsed_response["data"]
    videos = []
    vids.each do |vid|
      content = Content.find_by(content_id: vid["uri"].gsub(/[^\d]/, ''))
      if !content.nil?
        videos.push(vid)
      else
        videos << Content.create(
          content_id: vid["uri"].gsub(/[^\d]/, ''),
          text: vid["description"],
          create_time: vid["created_time"],
          favorites: vid["metadata"]["connections"]["likes"]["total"],
          retweet_count: nil,
          creator_id: self.id,
          provider: "vimeo"
        )
      end
    end
    return videos
  end

end
