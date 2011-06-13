class MailInterceptor
  def self.delivering_email(message)
    message.subject = "[#{message.to} #{message.subject}]"
    message.to = "intownllc@gmail.com"
  end
end
