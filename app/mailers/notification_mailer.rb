class NotificationMailer < ActionMailer::Base
  default from: "notifications@cliqwith.me"

  def notification user, other_user
    @user = user
    @other_user = other_user
    mail(to: @user.email, subject: "You have a new message from #{other_user.first_name}!")
  end
end
