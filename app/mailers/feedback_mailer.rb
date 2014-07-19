class FeedbackMailer < ActionMailer::Base
  default to: ['hsia.kenneth@gmail.com', 'andylee.hzl@gmail.com', 'romeo@cliqwith.me']
  default from: 'feedback@cliqwith.me'

  def feedback content, user
    @user = user
    @content = content
    mail(subject: "Feedback from #{user.name}!")
  end
end
