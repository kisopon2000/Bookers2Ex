class ContactMailer < ApplicationMailer

  def send_mail(title, content, group)
    @title = title
    @content = content
    @group = group
    mail bcc: group.users.pluck(:email), subject: title
  end
end
