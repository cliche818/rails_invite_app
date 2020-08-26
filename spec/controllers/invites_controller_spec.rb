require 'rails_helper'

RSpec.describe InvitesController, type: :controller do

  describe "POST join_invite" do
    let(:user) { users(:another_user) }

    before do
      login_as(user)
    end

    describe "joining companies" do
      it "should use the invite and join the company for the logged in user" do
        company_invite = invites(:unused_company_invite)
        post :join_invite, params: { invite: {invite_code: company_invite.invite_code} }

        expect(flash[:success]).to eq("You are now a member of BBBB Inc.")
        expect(response).to redirect_to(user_path)

        user.reload
        expect(user.companies.count).to eq(1)
        expect(user.companies.first.name).to eq("BBBB Inc.")

        company_invite.reload
        expect(company_invite.status).to eq(Invite.statuses[:used])
        expect(company_invite.user_id).to eq(user.id)
      end
    end

    describe "joining projects" do
      it "should use the invite and join the project for the logged in user" do
        project_invite = invites(:unused_project_invite)
        post :join_invite, params: { invite: {invite_code: project_invite.invite_code} }

        expect(flash[:success]).to eq("You are now a member of Highway 400")
        expect(response).to redirect_to(user_path)

        user.reload
        expect(user.projects.count).to eq(1)
        expect(user.projects.first.name).to eq("Highway 400")

        project_invite.reload
        expect(project_invite.status).to eq(Invite.statuses[:used])
        expect(project_invite.user_id).to eq(user.id)
      end
    end
  end
end