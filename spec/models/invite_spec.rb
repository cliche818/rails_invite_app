# frozen_string_literal: true

require "rails_helper"

RSpec.describe Invite, type: :model do
  describe "#used" do
    it "should return true if the status is used" do
      invite = invites(:used_invite)

      expect(invite.used?).to eq(true)
    end

    it "should return false if the status is not used" do
      invite = invites(:unused_invite)

      expect(invite.used?).to eq(false)
    end
  end
end