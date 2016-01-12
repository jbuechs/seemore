require 'rails_helper'

RSpec.describe CreatorsController, type: :controller do

  describe "search" do
    let (:vimeo_search_params) {
      { params: { vimeoquery: "Hello" } }
    }
    let (:twitter_search_params) {
      { params: { twitterquery: "Hello" } }
    }
    let (:invalid_search_params) {
      { params: { twitterquery: "" } }
    }
    context "vimeo query" do
      it "redirects to search page" do
        get :search, vimeo_search_params
        expect(subject).to redirect_to :search

      end
    end
    # context "twitter query" do
    #   it "returns an array of Creators from twitter" do
    #
    #   end
    # end
  end

end
