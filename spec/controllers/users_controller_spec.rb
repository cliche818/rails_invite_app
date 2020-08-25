require 'rails_helper'

RSpec.describe UsersController, type: :controller do
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
      post :create, params: { user: { name: "Joanne", email: "joanne@test.hoost" } }
      expect(flash[:success]).to eq("Thank you for signing up")
      expect(response).to redirect_to(user_path)
    end

    it "renders error if invalid" do
      post :create, params: { user: { name: "Joanne", email: user.email } }
      expect(flash[:error]).to eq("Please complete all required info and try again")
      expect(response).to redirect_to(new_user_path)
    end

    describe "joining company via company invite" do
      it "adds the company from the invite to the list of companies the user has" do
        company_invite = company_invites(:unused_invite)

        post :create, params: { user: { name: "Joanne", email: "joanne@test.hoost" }, invite: {invite_type: "CompanyInvite", invite_code: company_invite.invite_code} }

        expect(flash[:success]).to eq("Welcome! You are now a member of ACME Inc.")
        expect(response).to redirect_to(user_path)

        user = User.find_by(email: "joanne@test.hoost")
        expect(user.companies.count).to eq(1)
        expect(user.companies.first.name).to eq("ACME Inc.")
      end
    end  
  end

end
