# frozen_string_literal: true

class UnauthorizedError < StandardError; end

# We need this to setup AdminConstraint in routes.rb
# It restores the session earlier in the stack
class AuthMiddleware
  def initialize(app)
    @app = app
  end

  def call(env)
    request = ActionDispatch::Request.new(env)
    Current.session = Session.find_by(id: request.cookie_jar.signed[:session_id])

    @app.call(env)
  rescue UnauthorizedError
    [302, { Location: '/session/new' }, []]
  end
end

Rails.application.config.middleware.use(AuthMiddleware)
