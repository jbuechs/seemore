class UsersController < ApplicationController
  def show
  end

  def feed
    if session[:user_id].nil?
      redirect_to login_path
    end
  end

  def delete
  end

  def create
  end

  # adds a creator to the user's list
  def update
    # if the creator already exists, get the creator and add to user's list
    # if the creator does not exist, create creator and add to user's list
    creator = Creator.create(creator_hash(params))
    current_user.creators << creator
    raise
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
