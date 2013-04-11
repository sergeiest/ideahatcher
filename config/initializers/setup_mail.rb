# Initialize the rails application
ActionMailer::Base.smtp_settings = {
    :enable_starttls_auto => true, #works in ruby 1.8.7 and above
    :address => "smtp.gmail.com",
    :port => 587,
    :domain => "capitalround.com",
    :authentication => :plain,
    :user_name => "team@capitalround.com",
    :password => "we will raise money"

}
