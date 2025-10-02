module Users::Confirmation
  extend ActiveSupport::Concern

  def confirmed?
    !!self.confirmed_at
  end

  def unconfirmed?
    !self.confirmed_at
  end

  def generate_confirmation_token
    if self.confirmation_token && !confirmation_period_expired?
      self.confirmation_token
    else
      self.confirmation_token = Devise.friendly_token
    end
  end

  def confirmation_required?
    !self.confirmed_at
  end

  def confirmation_period_expired?
    Devise.confirm_within && self.confirmation_sent_at && (Time.now.utc > self.confirmation_sent_at.utc + Devise.confirm_within)
  end

  def confirm(args = {})
    if confirmation_period_expired?
      self.errors.add(:email, :confirmation_period_expired,
        period: Devise::TimeInflector.time_ago_in_words(Devise.confirm_within.ago))
      false
    end

    if confirmation_required?
      self.update_columns({ confirmed_at: Time.now.utc })
    end
  end

  def confirm_email
    DirectExchangeEmailPublisher.new(
      message: {
        email: self.email,
        confirmation_token: self.confirmation_token,
        subject: I18n.t("mailer.confirmation.subject"),
        mailer_path: "user_mailer",
        mailer_template: "sign_up_email_confirmation"
      },
      options: {
        routing_key: "email_process",
        queue_name: "email_queue"
      }
    ).publish

    self.update_columns({ confirmation_sent_at: Time.now.utc })
  end
end
