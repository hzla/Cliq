class UserMailer < ActionMailer::Base
  default from: 'Cliq@cliqwith.me'
 
  def welcome_email(user, email)
    @user = user
    mail(to: email, subject: 'Welcome to Cliq!')
  end

  def invite_email(user, email)
  	@user = user
  	mail(to: email, subject: "#{@user.first_name} invited you to join Cliq!")
  end
end