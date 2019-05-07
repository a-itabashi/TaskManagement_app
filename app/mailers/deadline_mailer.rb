class DeadlineMailer < ApplicationMailer

  def deadline(list)
    @list = list
    mail to: list.user.email
    mail subject: "終了期限間近のタスクがあります"
  end
end
