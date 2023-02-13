class User < ApplicationRecord
  has_many :user_viewing_parties
  has_many :viewing_parties, through: :user_viewing_parties

  validates_presence_of :name
  validates_presence_of :email
  validates_presence_of :password 
  validates_presence_of :password_confirmation
  validates :email, uniqueness: true

  has_secure_password
end
