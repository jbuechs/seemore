class CreatorsController < ApplicationController
  include HTTParty
  LIMIT_PER_PAGE = 2

  #add an instance of a content creator to the database
  def create
    @tweet = twit.user_timeline(params[:username])[0].text

  end

  #use private methods to determine which api to search
  def search
    if !params[:vimeoquery].nil?
      # complete vimeo search
      @creators = vimeo_search(params[:vimeoquery])
    elsif !params[:twitterquery].nil?
      @creators = twitter_search(params[:twitterquery])
    else
      # nothing in either search field
    end

  end

  private
    def vimeo_search(query)
       response = HTTParty.get("https://api.vimeo.com/users?per_page=#{LIMIT_PER_PAGE}&query=#{query}", headers: {"Authorization" => "bearer #{ENV['VIMEO_ACCESS_TOKEN']}"})
       json_res = convert_to_json(response)
       vim_users = json_res["data"]
       videographers = []
       vim_users.each do |user|
         videographer = Creator.new
         videographer.p_id = get_vimeo_id(user["uri"])
         videographer.provider = "vimeo"
         videographer.username = user["name"]
         videographer.avatar_url = user["pictures"]["sizes"][2]["link"] if user["pictures"]
         # purposely do not save the videographer objects to the database,
         # as this is only for displaying
         videographers << videographer
       end
    return videographers
    end

    def convert_to_json(httparty_response)
      if httparty_response.class == HTTParty::Response
        return JSON.parse(httparty_response.parsed_response)
      else
        raise "Invalid type of input for API response"
      end
    end

    #method to configure twitter
    def twit
      Seemore::Application.config.twitter
    end

    def twitter_search(query)
      #searches for users
      tweet_users = twit.user_search(query)
      tweeters = []
      #makes a new creator for each returned object from twitter query
      tweet_users.each do |user|
        tweeter = Creator.new(
          p_id: user.id,
          provider: "twitter",
          avatar_url: user.profile_image_url,
          username: user.screen_name,
        )
        tweeters << tweeter
        raise
      end
      #returns an array of twitter creators
      return tweeters
    end

    # given a uri the method returns the vimeo user id
    # example: given "/users/12901182" the method returns 12901182
    def get_vimeo_id(uri)
      return uri.sub("/users/", "").to_i
    end


end
