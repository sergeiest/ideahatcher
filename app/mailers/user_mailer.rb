class UserMailer < ActionMailer::Base
  default from: "team@ideahatcher.co"

  def send_password (authentication, password)
    @password = password
    mail(:to => authentication.username, :subject => "ideaHatcher - Reset you password")
  end


  def send_idea (email, idea, name)
    @idea = idea
    @name = name
    mail(:to => email, :subject => "ideaHatcher - New message on Workspace")
  end

end
