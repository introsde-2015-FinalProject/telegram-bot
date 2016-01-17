#!/usr/bin/env ruby

require 'telegram/bot'
require 'rest-client'
require 'pp'

token = 'xxxxxxxxxxxxxxxxxxxxxxxxxxxxx'

Telegram::Bot::Client.run(token) do |bot|
	bot.listen do |message|
		case message.text

		when '/start'
			question = 'Welcome, who are you?'
		    # See more: https://core.telegram.org/bots/api#replykeyboardmarkup
		    answers = Telegram::Bot::Types::ReplyKeyboardMarkup
		    .new(keyboard: [%w(User Doctor), %w(Family)], one_time_keyboard: true)
		    
		    bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)

		when '/stop'
		    # See more: https://core.telegram.org/bots/api#replykeyboardhide
		    kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
		    bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)

		when /(User|Family|Doctor)/
			kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
			case message.text 
			when 'User'
				x = 'u'
			when 'Family'
				x = 'f'
			when 'Doctor'
				x = 'd'
			end
			text = 'Ok, you are a '+message.text+'!! Insert '+x+' and your id. e.g '+x+' 1 '
			bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: kb)

		when /u \d+/
			id = message.text.match(/\d+/)[0].to_i
			puts id.to_s
			if id > 5
				id = 5
			end
			response = RestClient.get 'https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/'+id.to_s
			person = JSON.parse(response)
			kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
			text = 'Hi '+person['firstname']+' '+person['lastname']+', how are you?'
			bot.api.send_message(chat_id: message.chat.id, text: text , reply_markup: kb)
		else
			bot.api.send_message(chat_id: message.chat.id, text: 'Sorry, I did not understand', reply_markup: kb)
		end

	end

end
