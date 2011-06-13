#require 'mail_interceptor'

# Gmail security key: 46852fd901
ActionMailer::Base.smtp_settings = {
  :address              => "smtp.gmail.com",
  :port                 => 587,
  :domain               => "gmail.com",
  :user_name            => "intownllc",
  :password             => "Sagehens47",
  :authentication       => "plain",
  :enable_starttls_auto => true
}
#ActionMailer::Base.register_interceptor(MailInterceptor) 
