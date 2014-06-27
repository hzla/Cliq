class UserMailer < ActionMailer::Base
  default from: 'notifications@example.com'
 
  def welcome_email(user, email)
    @user = user
    mail(to: email, subject: 'Welcome to Cliq!')
  end
end