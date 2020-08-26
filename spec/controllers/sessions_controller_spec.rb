require 'rails_helper'

RSpec.describe SessionsController, type: :controller do
  let(:user) { users(:another_user) }

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

    describe "joining company via company invite" do
      it "adds the company from the invite to the list of companies the user has" do
        company_invite = invites(:unused_company_invite)

        post :create, params: { session: { email: user.email }, invite: {invite_type: "Company", invite_code: company_invite.invite_code} }

        expect(flash[:success]).to eq("You are now a member of BBBB Inc.")
        expect(response).to redirect_to(user_path)

        user.reload
        expect(user.companies.count).to eq(1)
        expect(user.companies.first.name).to eq("BBBB Inc.")

        company_invite.reload
        expect(company_invite.status).to eq(Invite.statuses[:used])
        expect(company_invite.user_id).to eq(user.id)
      end

      it "should fail to log in if the company invite doesn't exist" do
        post :create, params: { session: { email: user.email }, invite: {invite_type: "Company", invite_code: "non-existent-invite"} }

        expect(flash[:error]).to eq("Failed to log in because of invalid invite, please try again")
        expect(response).to redirect_to(new_session_path)
      end

      it "should fail to log in if the company invite doesn't have the right type" do
        company_invite = invites(:unused_company_invite)
        post :create, params: { session: { email: user.email }, invite: {invite_type: "BadInvite", invite_code: company_invite.invite_code} }

        expect(flash[:error]).to eq("Failed to log in because of invalid invite, please try again")
        expect(response).to redirect_to(new_session_path)
      end

      it "should fail to log in if the company invite is used already" do
        company_invite = invites(:used_company_invite)
        post :create, params: { session: { email: user.email }, invite: {invite_type: "Company", invite_code: company_invite.invite_code} }

        expect(flash[:error]).to eq("Failed to log in because invite has been used already, please try again")
        expect(response).to redirect_to(new_session_path)
      end
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
