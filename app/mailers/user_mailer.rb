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

  def send_welcome (email, name)
    @name = name
    mail(:to => email, :subject => "Welcome to ideaHatcher")
  end

  def send_welcome_tri_valley (email, name, password)
    @name = name
    @password = password
    @email = email
    mail(:to => email, :subject => "Join Startup Tri-Valley community")
  end

end
