require_relative '../config/environment'
Slack.configure do |config|
  config.token = ENV['SLACK_TOKEN']
  raise 'Missing ENV[SLACK_TOKEN]!' unless config.token
end

class SlackClient
  attr_accessor :client

  def initialize(client)
    @client = client
  end

#data = im.list
  def ping_qbot
    client.chat_postMessage(channel: 'DC2AK85HD', text: 'who is on?', as_user: true)
    sleep(30.seconds)
    data = client.im_history(channel: 'DC2AK85HD')
    message = data.messages.first.text.scan(/^(.*)/).slice(2, 20)
    users = get_users(message)
    users.each do |user|
      self.ping_member(user) unless user.nil?
    end
  end

  def get_users(message)
    message.collect do |el|
      el = el[0].split(' | ')
      if el && el[3].to_i >= 25
        name = el[0].split(': ')[0].strip
        user_data = client.users_search(user: name).members[0]
        user_data
      end
    end.compact
  end

  def ping_member(user_data)
    res = client.im_open(user: user_data.id)
    client.chat_postMessage(channel: res.channel.id, text: "Yo Dawg, time is up!", as_user: true)
  end

end
