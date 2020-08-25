class User < ApplicationRecord

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true

  has_many :company_users
  has_many :companies, through: :company_users
end
