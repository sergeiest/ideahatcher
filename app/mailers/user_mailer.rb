class UserMailer < ActionMailer::Base
  default from: "info@capitalround.com"

  def send_password (authentication, password)
    @password = password
    mail(:to => authentication.username, :subject => "Capital Round - Reset you password")
  end


  def send_idea (email, idea, name)
    @idea = idea
    @name = name
    mail(:to => email, :subject => "Capital Round - New message on Workspace")
  end

end
