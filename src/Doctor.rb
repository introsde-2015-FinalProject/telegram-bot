class Doctor
  def initialize
    @pcs_addr = "https://pcs-nameless-cove-5229.herokuapp.com/sdelab/doctor/"
    @bls_addr = "https://bls-desolate-falls-2352.herokuapp.com/sdelab/doctor/"
  end


  def help()
    help= "******* These are the methdos allowed for Doctor *******\n
     Check the patient condition -> check <id_person> \n
     Get list of patients -> list_patients"
    help
  end

  def checkPatient(doctorId, personId)
    addr = @pcs_addr.to_s + doctorId.to_s + '/person/' + personId.to_s
    puts 'checkPatient methods... ' + addr
    response = RestClient.get addr
    if response.code == 200
      result = JSON.parse(response)
      pp result
      text = ""
      result.each do |key, hash|
        text <<"#{key} -- "
        text << hash['Value'] + ' ' + hash[key] + " \n "
      end
      else
        text = "error in server"
      end
    return text
  end

  def getListPatients(doctorId)
    addr = @bls_addr.to_s + doctorId.to_s + '/patients'
    puts 'getListPatients methods... ' + addr
    response = RestClient.get addr
    text = ""
    if response.code == 200
      result = JSON.parse(response)
      pp result
      array = result['person']
      array.each do |x|
        text << x['firstname'] + ' ' + x['lastname'] + ' - ' + x['birthdate']+ "\n"
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