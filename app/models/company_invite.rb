class CompanyInvite < ApplicationRecord
  belongs_to :company

  validates :invite_code, presence: true

  enum status: { unused: "unused", used: "used" }

  def self.generate(company_id, invite_code)
    create(company_id: company_id, invite_code: invite_code, status: CompanyInvite.statuses[:unused])
  end  
end  