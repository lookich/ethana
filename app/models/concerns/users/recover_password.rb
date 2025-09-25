module Users::RecoverPassword
  protected
    def send_reset_password_instructions_notification(token)
      DirectExchangeEmailPublisher.new(
        message: {
          email: self.email,
          reset_password_token: self.reset_password_token,
          subject: I18n.t("mailer.reset_password.subject"),
          mailer_path: "user_mailer",
          mailer_template: "reset_password_instructions"
        },
        options: {
          routing_key: "email_queue",
          queue_name: "email_queue"
        }
      ).publish
    end
end
