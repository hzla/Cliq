class UserMailer < ActionMailer::Base
  default from: 'notifications@example.com'
 
  def welcome_email(user)
    @user = user
    @url  = "localhost:3000#{user_path(user)}/activate/#{user.activation}"
    mail(to: @user.email, subject: 'Welcome to My Awesome Site')
  end
end