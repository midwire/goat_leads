# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class UserMailerPreview < ActionMailer::Preview
  def verify_email
    UserMailer.verify_email(User.take.id)
  end

  def new_user_welcome
    UserMailer.new_user_welcome(User.take.id)
  end
end
