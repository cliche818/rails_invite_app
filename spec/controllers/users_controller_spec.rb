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
        company_invite = invites(:unused_company_invite)

        post :create, params: { user: { name: "Joanne", email: "joanne@test.hoost" }, invite: {invite_code: company_invite.invite_code} }

        expect(flash[:success]).to eq("Welcome! You are now a member of BBBB Inc.")
        expect(response).to redirect_to(user_path)

        user = User.find_by(email: "joanne@test.hoost")
        expect(user.companies.count).to eq(1)
        expect(user.companies.first.name).to eq("BBBB Inc.")

        company_invite.reload
        expect(company_invite.status).to eq(Invite.statuses[:used])
        expect(company_invite.user_id).to eq(user.id)
      end
    end

    describe "joining a project via a project invite" do
      it "adds the project from the invite to the list of projects the user has" do
        project_invite = invites(:unused_project_invite)

        post :create, params: { user: { name: "Joanne", email: "joanne@test.hoost" }, invite: {invite_code: project_invite.invite_code} }

        expect(flash[:success]).to eq("Welcome! You are now a member of Highway 400")
        expect(response).to redirect_to(user_path)

        user = User.find_by(email: "joanne@test.hoost")
        expect(user.projects.count).to eq(1)
        expect(user.projects.first.name).to eq("Highway 400")

        project_invite.reload
        expect(project_invite.status).to eq(Invite.statuses[:used])
        expect(project_invite.user_id).to eq(user.id)
      end
    end

    describe "error cases for invites" do
      it "should fail user registration if the company invite doesn't exist" do
        post :create, params: { user: { name: "Joanne", email: "joanne@test.hoost" }, invite: {invite_code: "non-existent-invite"} }

        expect(flash[:error]).to eq("The invite does not exist, user registration failed")
        expect(response).to redirect_to(new_user_path)

        user = User.find_by(email: "joanne@test.hoost")
        expect(user).to be_nil
      end

      it "should fail user registration if the company invite is used already" do
        company_invite = invites(:used_company_invite)

        post :create, params: { user: { name: "Joanne", email: "joanne@test.hoost" }, invite: {invite_code: company_invite.invite_code} }
        expect(flash[:error]).to eq("The invite has been used already, user registration failed")
        expect(response).to redirect_to(new_user_path)

        user = User.find_by(email: "joanne@test.hoost")
        expect(user).to be_nil
      end
    end
  end

end
