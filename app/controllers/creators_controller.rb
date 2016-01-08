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
      vimeo_search(params[:vimeoquery])
    elsif !params[:twitterquery].nil?
      # complete twitter search
      raise
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
        # create user objects
        videographer = Videographer.new
        # populate videographer fields
        # videographer.uid = get_vimeo_id(user["uri"])
        # videographer.name = user["name"]
        # and so on
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

    # given a uri the method returns the vimeo user id
    # example: given "/users/12901182" the method returns 12901182
    def get_vimeo_id(uri)
      return uri.sub("/users/", "").to_i
    end


end
