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
end
