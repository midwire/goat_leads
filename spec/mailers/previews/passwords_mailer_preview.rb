# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/user_mailer
class PasswordsMailerPreview < ActionMailer::Preview
  def reset
    PasswordsMailer.reset(User.take.id)
  end
end
