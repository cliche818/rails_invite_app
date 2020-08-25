class Company < ApplicationRecord

  has_many :projects
  
  validates :name, presence: true

  has_many :company_users
  has_many :users, through: :company_users

  has_many :invites, as: :invitable
end
