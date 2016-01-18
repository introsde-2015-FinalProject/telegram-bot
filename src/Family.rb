class Family
  def initialize
    @bls_addr = "https://bls-desolate-falls-2352.herokuapp.com/sdelab/family/"
  end


  def help()
    help= "******* These are the methdos allowed for Family *******\n
    \nVisualize data of the family member -> visualize_data
    \nGet alarms -> receive_allarm"
    help
  end

  def getAlarms (familyId)
    addr = @bls_addr.to_s + familyId.to_s + '/person/alarm'
    puts 'getAlarms: ' + addr
    response = RestClient.get addr
    if response.code == 200
      alarm = JSON.parse(response)
      text = "Blood pressure max: "+alarm['Blood pressure max'].to_s+"\n 
      "+alarm['Message'].to_s+ "\n 
      Blood pressure min: "+ alarm['Blood pressure min'].to_s
    else
     text = "error in server"
   end
   return text
 end

 def visualizeData (familyId)
   addr = @bls_addr.to_s + familyId.to_s + '/person/measures'
   puts 'getAlarms: '+ addr
   response = RestClient.get addr
   if response.code == 200
     measures = JSON.parse(response)
     pp measures
     array = measures['measure']
     text = ""
     array.each do |x|
      text << x['measureDefinition']['measureName'] + ' = ' + x['value'].to_s + ' at ' + x['timestamp']+ "\n"
    end
  else
   text = "error in server"
 end
 return text
end


def bls_addr
  @bls_addr
end

def bls_addr=(bls)
  @bls_addr=bls
end


end