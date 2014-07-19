class NotificationMailer < ActionMailer::Base
  default from: "Notifications@cliqwith.me"

  def notification user, other_user
    @user = user
    @other_user = other_user
    mail(to: @user.email, subject: "You have a new message from #{other_user.first_name}!")
  end

  def event_notification user, other_user, event
  	@user = user
  	@other_user = other_user
  	@event = event
  	mail(to: @user.email, subject: "You have a new event invite from #{other_user.first_name}!")
  end
end
