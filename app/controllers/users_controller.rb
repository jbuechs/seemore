class UsersController < ApplicationController
  def show
  end

  def feed
    if session[:user_id].nil?
      redirect_to login_path
    end
    #the following code is JUST FOR TESTING
    @tweets =  Seemore::Application.config.twitter.user_timeline("taylorswift13")
    raise

  end

  def delete
  end

  def create
  end
end
