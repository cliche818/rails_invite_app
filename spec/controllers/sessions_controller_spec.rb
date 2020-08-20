require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { users(:default) }

  describe "GET new" do
    it "render page if not logged in" do
      get :new
      expect(response).to be_successful
    end

    it "redirects to dashboard if logged in" do
      login_as(users(:default))
      get :new
      expect(response).to redirect_to(user_path)
    end
  end

  describe "POST create" do
    it "redirects to dashboard if successful" do
      post :create, params: { session: { email: user.email } }
      expect(flash[:success]).to eq("You are logged in")
      expect(response).to redirect_to(user_path)
    end

    it "renders error if invalid" do
      post :create, params: { session: { email: "bogus@test.host" } }
      expect(flash[:error]).to eq("Failed to log in, please try again")
      expect(response).to redirect_to(new_session_path)
    end
  end

  describe "DELETE destroy" do
    it "redirects to login if logged in" do
      login_as(user)
      delete :destroy
      expect(flash[:success]).to eq("You are now logged out")
      expect(response).to redirect_to(new_session_path)
      expect(session[:user_id]).to be_nil
    end

    it "redirects to login if not" do
      delete :destroy
      expect(response).to redirect_to(new_session_path)
    end
  end
end
