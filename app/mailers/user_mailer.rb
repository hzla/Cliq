class UserMailer < ActionMailer::Base
  default from: 'welcome@cliqwith.me'
 
  def welcome_email(user, email)
    @user = user
    mail(to: email, subject: 'Welcome to Cliq!')
  end
end