class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Allowlist
  include Users::Allowlist
  include Users::Confirmation
  include Users::Notification

  # :confirmable, :rememberable, :lockable, :timeoutable, :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self
  include Users::RecoverPassword
  has_many :notifications, dependent: :destroy

  encrypts :mobile_phone, deterministic: true

  validates :email, presence: true, uniqueness: true
  validates :password, presence: true
  # validates :mobile_phone, uniqueness: true
  before_create :generate_confirmation_token, if: :confirmation_required?

  after_create :confirm_email, unless: :skip_callbacks_in_test?

  def skip_callbacks_in_test?
    Rails.env.test?
  end

  def self.confirm_by_token(confirmation_token)
    if confirmation_token.blank?
      confirmable = new
      confirmable.errors.add(:confirmation_token, :blank)
      return confirmable
    end

    confirmable = self.find_by(confirmation_token: confirmation_token)

    unless confirmable
      confirmation_digest = Devise.token_generator.digest(self, :confirmation_token, confirmation_token)
      confirmable = self.find_or_create_by(confirmation_token: confirmation_digest)
    end

    confirmable.confirm if confirmable.persisted?
    confirmable
  end
end
