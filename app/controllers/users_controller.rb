class UsersController < ApplicationController
  def show
    @creators = current_user.creators
  end

  def feed
    if session[:user_id].nil?
      redirect_to login_path
    else
      @contents = current_user.contents.flatten
      @contents = @contents.flatten.sort_by! { |content| content[:create_time] }.reverse
      binding.pry
      render "feed"
    end
  end

  def delete
  end

  def create
  end

  # adds a creator to the user's list
  def update
    creator, following = current_user.following(params["provider"], params["p_id"])
    if !following
      if creator.nil?
      # if the creator does not exist, create creator
        creator = Creator.create(creator_hash(params))
        creator.get_content
      end
      current_user.creators << creator
      flash[:notice] = "#{creator.username} has been added to your feed!"
    end
    redirect_to root_path
  end

  #remove a creator from a user's follow list
  def delete_creator
    # find creator from params
    creator = Creator.find_by(provider: params["provider"], p_id: params["p_id"])
    # remove creator from user's list
    current_user.creators.delete(creator)
    # if the creator is no longer followed, delete it
    creator.delete if creator.users.nil?
    redirect_to current_user
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
