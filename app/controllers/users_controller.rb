class UsersController < ApplicationController
  def show
    @creators = current_user.creators
  end

  def feed
    if session[:user_id].nil?
      redirect_to login_path
    end
    #the following code is JUST FOR TESTING
    @tweets =  Seemore::Application.config.twitter.user_timeline("bumbbles21")
  end

  def delete
  end

  def create
  end

  # adds a creator to the user's list
  def update
    # if the creator already exists, get the creator and add to user's list
    creator = Creator.where("provider = ? AND p_id = ?", params["provider"], params["p_id"])
    if !creator.exists?
      # if the creator does not exist, create creator and add to user's list
      creator = Creator.create(creator_hash(params))
      creator.get_content
    else
    # Creator.where method returns an array of creators. Need to pull out the first
      creator = creator.first
    end
    current_user.creators << creator if current_user.creators
    flash[:notice] = "#{creator.username} has been added to your feed!"
    redirect_to root_path
  end

  #remove a creator from a user's follow list
  def delete_creator
    # somehow search for creator based on params
    # creator = Creator.where("provider = ? AND p_id = ?", params["provider"], params["p_id"])
    # remove creator from user's list
    # self.creators.delete(creator)
    # if the creator is no longer followed, delete it
    # creator.delete if creator.users.nil?
  end

  private
  def creator_hash(params)
    creator_hash = {}
    creator_hash[:p_id] = params["p_id"]
    creator_hash[:username] = params["username"]
    creator_hash[:avatar_url] = params["avatar_url"]
    creator_hash[:provider] = params["provider"]
    return creator_hash
  end
end
