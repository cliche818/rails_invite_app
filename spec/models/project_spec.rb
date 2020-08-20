# frozen_string_literal: true

require "rails_helper"

RSpec.describe Project, type: :model do

  it "validates presence" do
    project = Project.new
    expect(project).to be_invalid
    expect(project.errors[:name]).to include("can't be blank")
    expect(project.errors[:company]).to include("must exist")
  end

end
