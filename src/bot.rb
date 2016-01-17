#!/usr/bin/env ruby

  require 'telegram/bot'
	require 'rest-client'
	require 'pp'
  require_relative 'Person'

	token = '177899404:AAGAOaYV8QXTFIkQTRsPTxaBcAlA-Upb31g'
  $id_Person = 0
  $id_Doctor = 0
  $id_Family = 0

  $mode = "json"
  $units = "metric"

  # *************** PCS ********************
  #******** GET PCS *********
  #RestClient.get 'http://example.com/resource', :params => {:foo => 'bar', :baz => 'qux'}
  # will GET http://example.com/resource?foo=bar&baz=qux

  #Person
  #https://pcs-nameless-cove-5229.herokuapp.com/sdelab/person/person_id/measure?measure=1&value=45
  pcs_addr = "https://pcs-nameless-cove-5229.herokuapp.com/sdelab/person/person_id/measure"

  #Doctor
  pcs_addr_check_patient = "https://pcs-nameless-cove-5229.herokuapp.com/sdelab/person/doctor_id/person_id"


  #***** BLS *******
  #*** GET *****
  bls_addr = "https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/"




	Telegram::Bot::Client.run(token) do |bot|
		bot.listen do |message|
			case message.text

			when '/start'
				question = 'Welcome, who are you?'
					# See more: https://core.telegram.org/bots/api#replykeyboardmarkup
					answers = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(User Doctor), %w(Family)], one_time_keyboard: true)

					bot.api.send_message(chat_id: message.chat.id, text: question, reply_markup: answers)



			when '/stop'
					# See more: https://core.telegram.org/bots/api#replykeyboardhide
					kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
					bot.api.send_message(chat_id: message.chat.id, text: 'Sorry to see you go :(', reply_markup: kb)

      when '/help -p'
         obj_person = Person.new
         obj_person.help()
         kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
         bot.api.send_message(chat_id: message.chat.id, text: obj_person.help(), reply_markup: kb)

    #Person calls
      #show person detail
      when 'p -show'
        puts "Id person inside if p -show "+$id_Person.to_s
        puts $id_Person != 0
        if $id_Person != 0
           puts "inside if"
           obj_person = Person.new()
           text = obj_person.viewPerson($id_Person)
           puts text.to_s
           kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
           bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: kb)
        end

      #Create new person
      when /p\s-create/
        b=message.text.gsub(/\s+/m, ' ').strip.split(" ")
        puts b.size
        puts "b[2]"+b[2]
        puts "b[3]"+b[3]
        puts "b[4]"+b[4]
        puts "b[5]"+b[5]
        puts "b[6]"+b[6]
        puts "b[7]"+b[7]
        if b.size === 8
           firstname = b[2]
           lastname = b[3]
           birthdate = b[4]
           email = b[5]
           fiscalcode = b[6]
           gender = b[7]

           #puts firstname
           #puts lastname
           #puts birthdate
           #puts email
           #puts fiscalcode
           #puts gender
           obj_person = Person.new()
           text = obj_person.createPerson(firstname,lastname,birthdate,email,fiscalcode,gender)
           puts "Response of method post in bot: "+ text.to_s
           kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
           bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: kb)

        else
           puts "You just making it up!"
        end


    #Delete Person
      when /pDelete \d+/
        id = message.text.match(/\d+/)[0].to_i
        #puts "Id person inside if p -show "+$id_Person.to_s
        #puts $id_Person != 0
        if id != 0
          puts "inside if delete"
          obj_person = Person.new()
          text = obj_person.deletePerson(id)
          puts text.to_s
          kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: kb)
        end


    #show weather
      when /pWeather \S*/
        b=message.text.gsub(/\s+/m, ' ').strip.split(" ")
        id = 1
        puts b.size
        if b.size  < 3
          city=b[1]
          puts b[1]
          puts "The city variable is: "+city

          obj_person = Person.new()
          text = obj_person.getWeather(id,city,$units,$mode)
          puts text.to_s
          kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: kb)
        end


			when /(User|Family|Doctor)/
				kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
				case message.text
					when 'User'
            ask_id = "Welcome Person: insert your p=<id_number>"
            kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
            bot.api.send_message(chat_id: message.chat.id, text: ask_id, reply_markup: kb)
            #x = 'u'

          when 'Family'
            ask_id = "Welcome Doctor: insert your d=<id_number>"
            kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
            bot.api.send_message(chat_id: message.chat.id, text: ask_id, reply_markup: kb)
            #x = 'f'

          when 'Doctor'
            ask_id = "Welcome Faamily: insert your f=<id_number>"
            kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
            bot.api.send_message(chat_id: message.chat.id, text: ask_id, reply_markup: kb)
            #x = 'd'

				end
				#text = 'Ok, you are a '+message.text+'!! Insert '+x+' and your id. e.g '+x+' 1 '
				#bot.api.send_message(chat_id: message.chat.id, text: text, reply_markup: kb)


      when /p= \d+/
        id = message.text.match(/\d+/)[0].to_i
        $id_Person = id
        puts "Id person: " + $id_Person.to_s
        puts id.to_s
        response = RestClient.get 'https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/'+$id_Person.to_s
        if response.code != 200
          error_message = "Wrong id... Please reinsert your id: "
          bot.api.send_message(chat_id: message.chat.id, text: welcome_person, reply_markup: answers_user)
        else
          welcome_person = "Push getInfo button to receive last info about you"
          answers_user = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(GetInfo)], one_time_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: welcome_person, reply_markup: answers_user)
        end

      when /d= \d+/
        id = message.text.match(/\d+/)[0].to_i
        $id_Doctor = id
        puts "Id doctor: " + $id_Doctor.to_s
        puts id.to_s
        response = RestClient.get 'https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/'+$id_Doctor.to_s
        if response.code != 200
          error_message = "Wrong id... Please reinsert your id: "
          bot.api.send_message(chat_id: message.chat.id, text: welcome_person, reply_markup: answers_user)
        else
          welcome_person = "Push getInfo button to receive last info about you"
          answers_user = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(GetInfo)], one_time_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: welcome_person, reply_markup: answers_user)
        end

      when /f= \d+/
        id = message.text.match(/\d+/)[0].to_i
        $id_Family = id
        puts "Id family: " + $id_Family.to_s
        puts id.to_s
        response = RestClient.get 'https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/'+$id_Family.to_s
        if response.code != 200
          error_message = "Wrong id... Please reinsert your id: "
          bot.api.send_message(chat_id: message.chat.id, text: welcome_person, reply_markup: answers_user)
        else
          welcome_person = "Push getInfo button to receive last info about you"
          answers_user = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(GetInfo)], one_time_keyboard: true)
          bot.api.send_message(chat_id: message.chat.id, text: welcome_person, reply_markup: answers_user)
        end


      when 'Person'
				welcome_person = "Push getInfo button to receive last info about you"
        answers_user = Telegram::Bot::Types::ReplyKeyboardMarkup.new(keyboard: [%w(GetInfo)], one_time_keyboard: true)
				bot.api.send_message(chat_id: message.chat.id, text: welcome_person, reply_markup: answers_user)

      when 'GetInfo'
        error_message = "Good your data are: "
        response = RestClient.get 'https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/'+$id_Person.to_s
        person = JSON.parse(response)
        kb = Telegram::Bot::Types::ReplyKeyboardHide.new(hide_keyboard: true)
        text = error_message+person['firstname']+' '+person['lastname']+'. How are you?'
        bot.api.send_message(chat_id: message.chat.id, text: text , reply_markup: kb)


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
