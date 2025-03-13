# frozen_string_literal: true

module AuthMacros
  def login_user(user = create(:user, :confirmed))
    start_new_session_for(user)
    user
  end

  def logout_user(user)
    terminate_session
    user
  end

  private

  def start_new_session_for(user)
    user.sessions.create!(user_agent: 'rspec', ip_address: '127.0.0.1').tap do |session|
      Current.session = session
      cookies[:session_id] = session.id
    end
  end

  def terminate_session
    Current.session.destroy
    cookies.delete(:session_id)
  end
end

# Monkey-patch the Authentication concern for test environment
module Authentication
  private

  def find_session_by_cookie
    Session.find_by(id: cookies[:session_id])
  end
end

RSpec.configuration.include AuthMacros, type: :controller
RSpec.configuration.include AuthMacros, type: :request
