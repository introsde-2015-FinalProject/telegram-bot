require 'rest-client'
require 'pp'

response = RestClient.get 'https://bls-desolate-falls-2352.herokuapp.com/sdelab/person/1'
person = JSON.parse(response)
pp person
puts person['firstname']
puts person['lastname']
puts response