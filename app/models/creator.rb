class Creator < ActiveRecord::Base
  has_many :content
  has_and_belongs_to_many :users
  validates :p_id, :provider, :username, presence: true

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
    else
      get_videos
    end
  end

  def get_tweets
    # api call to get the tweets and save to database
  end

  def get_videos
    # api call to get the videos and save to database
  end
end
