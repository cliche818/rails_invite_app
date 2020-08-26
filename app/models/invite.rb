class Invite < ApplicationRecord
  belongs_to :invitable, polymorphic: true
  belongs_to :user, optional: true

  validates :invite_code, presence: true

  enum status: { unused: "unused", used: "used" }

  def self.generate(invite_code, invitable)
    if invitable.class.name == "Company" || invitable.class.name == "Project"
      create(invitable_id: invitable.id, invitable_type: invitable.class.name, invite_code: invite_code, status: Invite.statuses[:unused])
    end
  end

  def used?
    status == Invite.statuses[:used]
  end
end  