require_relative '../config/environment'
require_relative './time_check_bot'
slacker = SlackClient.new(Slack::Web::Client.new)

while slacker do
  slacker.ping_qbot
  sleep(1.minute)
end
