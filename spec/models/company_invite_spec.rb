# frozen_string_literal: true

require "rails_helper"

RSpec.describe CompanyInvite, type: :model do
  describe "#used" do
    it "should return true if the status is used" do
      invite = company_invites(:used_invite)

      expect(invite.used?).to eq(true)
    end

    it "should return false if the status is not used" do
      invite = company_invites(:unused_invite)

      expect(invite.used?).to eq(false)
    end
  end
end