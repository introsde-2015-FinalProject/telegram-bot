class Person
  def initialize
    @bls_addr = "https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/"
  end


  def help()
    help= "******* These are the methdos allowed for Person *******\n
     Create new Person -> p -create <firstname> <lastname> <birthdate{yyyy-MM-dd}> <email> <fiscalcode> <gender>
     \nView person Detail -> p -show
     \nDelete a person -> pDelete <id>
     \nView currentHealth -> p -show h
     \nView list of measure -> p -show list measure
     \nShow measure -> p -show m<1>
     \nCheck measure -> p -m<1>
     \nCreate new Reminder -> p -create reminder <autocreate{false}> <createReminder{yyyy-MM-dd}> <expireReminder{yyyy-MM-dd}> <relevanceLevel{1-5}> <text>
     \nShow Person reminders -> p -show reminder
     \nCreate new target -> p -create target <achieved{false}> <conditionTarget{<,>}> <endDateTarget{yyyy-MM-dd}> <startDateTarget{yyyy-MM-dd}>
     \nShow target list -> p -show target
     \nShow list target for measureDef -> p -show target -m<1>
     \nCheck vital signs -> p -m<1> <value> <endvalue> <startvalue>
     \nGet motivation phrase -> p -motivation
     \nGet daily weather information -> p -weather <city,nation> <metric> <json>
     \nGet forecast weather information -> -forecast <city,nation> <metric> <json>"
    help
  end


  #RestClient.post "http://example.com/resource", { 'x' => 1 }.to_json, :content_type => :json, :accept => :json
  public
  def createPerson(firstname,lastname,birthdate,email,fiscalcode,gender)
    addr = @bls_addr.to_s
    #@bls_addr.to_s+personId.to_s
    puts addr
    puts "Inside the create Person !!! "
    sez = {'firstname' => firstname,'lastname' => lastname,'birthdate' => birthdate,'email' => email,'fiscalcode' => fiscalcode,'gender' => gender}
    puts sez
    response = RestClient.post addr.to_s, {'firstname' => firstname,'lastname' => lastname,'birthdate' => birthdate,'email' => email,'fiscalcode' => fiscalcode,'gender' => gender}.to_json,
                               :content_type => :json, :accept => 'text/plain'
    #puts respose.request
    #puts response
    #person = JSON.parse(response)
    #puts person
  end

  public
  def viewPerson(personId)
    addr = @bls_addr.to_s + personId.to_s
    #@bls_addr.to_s+personId.to_s
    puts addr
    puts "Inside the method viewPerson !!! "
    response = RestClient.get addr
    person = JSON.parse(response)
    text = "Firstname: "+person['firstname']+"\n Lastname: "+person['lastname']+ "\n Birthdate: "+ person['birthdate']+"\n Gender: "+person['gender']
    return text
  end


  public
  def deletePerson(personId)
    addr = @bls_addr.to_s + personId.to_s
    #@bls_addr.to_s+personId.to_s
    puts addr
    puts "Inside the method deletePerson !!! "
    response = RestClient.delete addr
    #person = JSON.parse(response)
    #text = "Firstname: "+person['firstname']+"\n Lastname: "+person['lastname']+ "\n Birthdate: "+ person['birthdate']+"\n Gender: "+person['gender']
    #return text
  end


#https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/person_id/weather?city=city&units=units&mode=mode
  #RestClient.get 'http://example.com/resource', :params => {:foo => 'bar', :baz => 'qux'}
  # will GET http://example.com/resource?foo=bar&baz=qux
  public
  def getWeather(personId,city,units,mode)

    addr = @bls_addr.to_s + personId.to_s+"/weather"
    #@bls_addr.to_s+personId.to_s
    puts addr
    puts "Inside the method getWeather !!! "
    response = RestClient.get addr, :params => {:city => city, :units => units, :mode => mode}
    weather = JSON.parse(response)
    text = " Condition: "+weather['Condition']+"\n Current Temperature: "+weather['Motivation']+ "\n Temperature max: "+ weather['Temperature max']+"\n Temperature min: " +weather['Temperature min']+"\n Pressure "+weather['Pressure']
    return text
  end





  def bls_addr
    @bls_addr
  end

  def bls_addr=(bls)
    @bls_addr=bls
  end


end