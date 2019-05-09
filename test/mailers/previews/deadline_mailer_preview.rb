class DeadlineMailerPreview < ActionMailer::Preview

  # Preview this email at
  # http://localhost:3000/rails/mailers/deadline_mailer/send_mailer
  def send_mailer
    DeadlineMailer.send_mailer
  end
end