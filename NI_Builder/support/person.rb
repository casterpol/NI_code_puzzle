class Person
  attr_accessor :first_names, :last_name, :address, :hobby, :date_of_birth,
                :country_of_birth, :favourite_food, :ni_number

  def initialize(person:)
    @first_names = person['First names']
    @last_name = person['Last name']
    @address = person['Address']
    @hobby = person['Hobby']
    @date_of_birth = person['Date of Birth']
    @country_of_birth = person['Country of Birth']
    @favourite_food = person['Favourite Food']
  end

  def generate_ni_number(optional_space:)
    @ni_number = NationalInsurance.build(person: self, optional_space: optional_space)
  end

  def convert_to_string_arr
    self.instance_variables.map{ |attribute| self.instance_variable_get(attribute).to_s }
  end
end
