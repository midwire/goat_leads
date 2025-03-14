# frozen_string_literal: true

# Send Slack messages to a channel
module SlackPipe
  module_function

  # Send a message to a Slack channel for debugging, or just for fun :)
  def send_msg(message, webhook = Rails.application.credentials.slack[:webhook_url])
    host = Socket.gethostname
    env = Rails.env
    msg = <<~STRING
      *#{host} - #{env}*:\n
      #{message}
    STRING
    notifier = Slack::Notifier.new(webhook, channel: Settings.notifications.slack_channel)
    notifier.ping(msg)
  end
end
