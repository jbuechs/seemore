class CreatorsController < ApplicationController
  include HTTParty
  LIMIT_PER_PAGE = 10

  #add an instance of a content creator to the database
  def create

  end

  #add a creator in a user's follow list
  def update

  end

  #use private methods to determine which api to search
  def search
    if !params[:vimeoquery].nil?
      # complete vimeo search
      @creators = vimeo_search(params[:vimeoquery])
    elsif !params[:twitterquery].nil?
      twitter_search(params[:twitterquery])
    else
      # nothing in either search field
    end

  end

  #remove a creator from a user's follow list
  def delete

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

    def twitter_search(query)
      twit = Seemore::Application.config.twitter
      tweeters = twit.user_search(query)
      @response = twit.user_search(query)[0].name
      @tweet = twit.user_timeline(query)[0].text
    end

    # given a uri the method returns the vimeo user id
    # example: given "/users/12901182" the method returns 12901182
    def get_vimeo_id(uri)
      return uri.sub("/users/", "").to_i
    end


end
