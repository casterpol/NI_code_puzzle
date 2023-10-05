module NationalInsurance
  def self.build(person:, optional_space:)
    space = ' ' if optional_space

    [first_name_initial(name: person.first_names),
     surname_initial(name: person.last_name),
     space,
     year_of_birth(dob: person.date_of_birth),
     space,
     random_code_integer(number_of_digits: NI_Constants.number_of_random_digits),
     space,
     country_of_birth(country: person.country_of_birth)].join
  end

  def self.first_name_initial(name:)
    # remove trailing full stop if present
    name.delete_suffix!(".")
    if name.include?(".")
      name.sub(/^\w*\.\s/, '').chars.first.upcase
    else
      name.chars.first.upcase
    end
  end

  def self.surname_initial(name:)
    name.chars.first.upcase
  end

  def self.year_of_birth(dob:)
    Date.parse(dob).strftime(NI_Constants.year_format)
  end

  def self.random_code_integer(number_of_digits:)
    number_of_digits.times.map { rand(10) }.join
  end

  def self.country_of_birth(country:)
    if NI_Constants.countries_to_count.include? country
      country.chars.first.upcase
    else
      NI_Constants.other_country_letter
    end
  end

  def self.add_unique_ni(list:, optional_space:)
    unique_ni_list = []
    check_ni_for_duplicates = Set.new

    list.each do |row|
      person = Person.new(person: row)
      person.generate_ni_number(optional_space: optional_space)

      while check_ni_for_duplicates.include?(person.ni_number)
        repeat_counter ||= 0
        if repeat_counter < NI_Constants.repeat_time_out
          person.generate_ni_number(optional_space: optional_space)
          repeat_counter += 1
        else
          raise ("unable to create unique ni for: #{person.first_names person.last_name}").colorize(:color => :red, :mode => :bold)
        end
      end

      check_ni_for_duplicates << person.ni_number
      unique_ni_list << person
    end

    unique_ni_list
  end

  def self.count_ni_country_of_births(ni_list:)
    countries_arr = []
    ni_list.each do |object|
      countries_arr << object.country_of_birth
    end

    results = {}
    NI_Constants.countries_to_count.each do |country|
      results[country] = countries_arr.count(country)
    end

    results['Other'] = countries_arr.count - results.values.sum

    puts ("Total number of records counted: #{countries_arr.count}\nTotal Count for each country is as follows:").colorize(:green)

    results.each do |key, value|
      puts ("#{key}: #{value}").colorize(:blue)
    end
  end
end
