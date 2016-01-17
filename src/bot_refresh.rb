#!/usr/bin/env ruby

require 'telegram/bot'
require 'rest-client'
require 'pp'

token = '177899404:AAGAOaYV8QXTFIkQTRsPTxaBcAlA-Upb31g'

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message.text

      when '/start'
        question = 'Welcome, who are you?'
        # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
        answers = Telegram::Bot::Types::ReplyKeyboardMarkup
                      .new(keyboard: [%w(User Doctor), %w(Family)], one_time_keyboard: true)

        bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)

      else
        kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
        bot.api.send_message(chat_id: message.chat.id, text: 'x', reply_markup: kb)
    end

  end

end