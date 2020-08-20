# frozen_string_literal: true

require "rails_helper"

RSpec.describe User, type: :model do

  it "validates presence" do
    user = User.new
    expect(user).to be_invalid
    expect(user.errors[:name]).to include("can't be blank")
    expect(user.errors[:email]).to include("can't be blank")
  end

end
