# frozen_string_literal: true

require "rails_helper"

RSpec.describe Company, type: :model do

  it "validates presence" do
    company = Company.new
    expect(company).to be_invalid
    expect(company.errors[:name]).to include("can't be blank")
  end

end
