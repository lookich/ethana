class Notification < ApplicationRecord
  enum :notification_type, %i[success error info warning promise promise-resolve promise-reject]

  belongs_to :user, dependent: :destroy
  validates :title, presence: true, length: { maximum: 55 }
  validates :body, presence: true, length: { maximum: 255 }
  validates :notification_type, presence: true
  validates :reciever_type, presence: true

  belongs_to :user

  scope :unviewed, -> { where(viewed: false) }
end
