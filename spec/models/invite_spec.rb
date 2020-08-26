# frozen_string_literal: true

require "rails_helper"

RSpec.describe Invite, type: :model do
  describe ".generate" do
    it "should generate an unused invite for a company" do
      company = companies(:new_company)
      Invite.generate("company_invite_code", company)

      invite = Invite.find_by(invite_code: "company_invite_code")
      expect(invite.invitable_id).to eq(company.id)
      expect(invite.invitable_type).to eq("Company")
      expect(invite.status).to eq(Invite.statuses[:unused])
    end

    it "should generate an unused invite for a project" do
      project = projects(:default)
      Invite.generate("project_invite_code", project)

      invite = Invite.find_by(invite_code: "project_invite_code")
      expect(invite.invitable_id).to eq(project.id)
      expect(invite.invitable_type).to eq("Project")
      expect(invite.status).to eq(Invite.statuses[:unused])
    end
  end

  describe "#used" do
    it "should return true if the status is used" do
      invite = invites(:used_company_invite)

      expect(invite.used?).to eq(true)
    end

    it "should return false if the status is not used" do
      invite = invites(:unused_company_invite)

      expect(invite.used?).to eq(false)
    end
  end
end