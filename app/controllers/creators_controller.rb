class CreatorsController < ApplicationController
  include HTTParty
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
      response = HTTParty.get("https://api.vimeo.com/users?query=#{query}", headers: {"Authorization" => "bearer #{ENV['VIMEO_ACCESS_TOKEN']}"})

      raise
    end

end
