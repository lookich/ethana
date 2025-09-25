class UserMailer < ApplicationMailer
  default from: ENV.fetch("APP_EMAIL", "from@example.com")

  def send_email
    @data = params[:data]
    @data["subject"] ||= "No subject"
    @data["mailer_path"] ||= "layouts"
    @data["mailer_template"] ||= "mailer"
    mail(
      to: "<#{@data["email"]}>",
      subject: "#{@data["subject"]}",
      template_path: "#{@data["mailer_path"]}",
      template_name: "#{@data["mailer_template"]}"
      )
  end
end
