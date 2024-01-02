# Load the Rails application.
require_relative "application"

# Initialize the Rails application.
Rails.application.initialize!


ActionMailer::Base.delivery_method = :smtp # Use SMTP for email delivery
ActionMailer::Base.perform_deliveries = true
ActionMailer::Base.smtp_settings = {
address: 'smtp.gmail.com', # Set your SMTP server address
port: 465, # Set the SMTP port (587 is common for TLS)
domain: 'gmail.com',
user_name: 'akshaygiyer@gmail.com', # Set your SMTP username
password: 'Aksh@2211', # Set your SMTP password
authentication: 'plain', # Use login authentication method
:ssl => true,
:tsl => true,
enable_starttls_auto: true, # Enable TLS
}