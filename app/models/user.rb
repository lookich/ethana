class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist
  include Users::Allowlist

  # :confirmable, :rememberable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

  encrypts :mobile_phone, deterministic: true

  validates :email, presence: true, uniqueness: true
  validates :mobile_phone, uniqueness: true
end
