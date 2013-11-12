# Initialize the rails application
ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true, #works in ruby 1.8.7 and above
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "ideahatcher.co",
    :authentication => :plain,
    :user_name => "team@ideahatcher.co",
    :password => "Yd3c5QXu" #ENV['EMAIL_PASSWORD']

}
