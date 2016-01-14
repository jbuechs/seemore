require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  # before { request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter] }
  let(:user) { create(:developer_user) }
  let(:creator) { create(:twitter_creator) }

  describe "GET #show" do
    it "renders the show view" do
      get :show, {id: user.id}, user_id: user.id
      expect(subject).to render_template :show
    end
    it "assigns current user's creators as @creators" do
      user.creators << creator
      creators = user.creators
      get :show, {id: user.id}, user_id: user.id
      expect(assigns(:creators)).to eq creators
    end
  end

  describe "GET #feed" do
    context "user is not logged in" do
      it "redirects to login_path" do
        get :feed, {id: user.id}, user_id: nil
        expect(subject).to redirect_to login_path
      end
    end
    context "user is logged in" do
      it "renders feed template" do
        get :feed, {id: user.id}, user_id: user.id
        expect(subject).to render_template :feed
      end
      it "assigns current user's content to @content" do

      end
    end
  end

  describe "PATCH #update" do
    context "creator does not exist" do
      let (:params) do
        {p_id: "567h567j",
        username: "l33ttw3et",
        avatar_url: "avatar_url.com",
        provider: "twitter"}
      end
      # test needs to have user logged in for a creator to be created or assigned
      it "makes a new creator" do
        @count = user.creators.all.count
        session[:user_id] = user.id
        patch :update, params.merge(id: user.id)
        expect(user.creators.all.count).to eq(@count + 1)
      end
      it "gets the content for the new creator" do
        patch :update, {id: user.id}, params
        expect(Creator.last.get_content[0]).is_a?(Content)
      end
    end
  end

  #
  # describe "GET #delete" do
  #
  # end
  #
  # describe "GET #create" do
  #
  # end

end
