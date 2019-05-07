# Preview all emails at http://localhost:3000/rails/mailers/deadline_mailer
class DeadlineMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/deadline_mailer/deadline
  def deadline
    DeadlineMailer.deadline
  end

end
