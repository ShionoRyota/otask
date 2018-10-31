class ApplicationMailer < ActionMailer::Base
  default from: 'Otask管理メール <info@hoge.com>',
          bcc:      "sent@gmail.com",
          reply_to: "reply@gmail.com"
  layout 'mailer'
end