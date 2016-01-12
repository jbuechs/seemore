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
  # describe "GET #show" do
  #
  # end
  #
  # describe "GET #feed" do
  #
  # end
  #
  # describe "GET #delete" do
  #
  # end
  #
  # describe "GET #create" do
  #
  # end

end
