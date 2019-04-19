class LinebotController < ApplicationController
    require 'line/bot'
  # callbackアクションのCSRFトークン認証を無効
  protect_from_forgery :except => [:callback]
  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      error 400 do 'Bad Request' end
    end
    events = client.parse_events_from(body)
    events.each { |event|
        case event
        when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          msg = event.message['text']
          id = msg.to_i
          if find_title(id)
            message = [{
            type: 'text',
            text: find_title(id)
            }]
          else
            message = [{
            type: 'text',
            text: "ないよ！"
            }]
          end
            client.reply_message(event['replyToken'], message)
        end
        end
    }
    head :ok
  end
private

  def client
    @client ||= Line::Bot::Client.new { |config|
      config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
      config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
    }
  end

  def find_title(num)
    title = Title.find_by(id: num)
    if title
      return title.name, title.center, title.release
    else
      nil
    end
  end

end
