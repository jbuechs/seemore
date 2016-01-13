require 'rails_helper'
require 'pry'

RSpec.describe CreatorsController, type: :controller do

  describe "GET#search" do
    let (:vimeo_search_params) {
      { vimeoquery: "Hello" }
    }
    let (:twitter_search_params) {
      { twitterquery: "Hello" }
    }
    let (:invalid_search_params) {
      { twitterquery: "" }
    }
    context "blank search" do
      it "creates a flash message" do
        get :search, invalid_search_params
        expect(flash["error"]).to_not be_nil
      end

      it "redirects to root_path" do
        @current_user = create(:user)
        session[:user_id] = @current_user.id
        get :search, invalid_search_params
        expect(subject).to redirect_to root_path
      end
    end

    context "vimeo query" do
      it "redirects to search page" do
        get :search, vimeo_search_params
        binding.pry
        expect(subject).to render_template :search
      end
    end

    context "twitter query" do
      it "returns an array of Creators from twitter" do
        get :search, twitter_search_params
        expect(subject).to render_template :search
      end
    end
  end

end
