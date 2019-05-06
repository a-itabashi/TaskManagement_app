class DeadlineMailer < ApplicationMailer

  def deadline(list)
    @list = list
    mail to: list.user.email
    mail subject: "終了期限間近のタスクがあります"


    # mail to: @announce_deadline.map{|u| u.user.email}
  end
end
