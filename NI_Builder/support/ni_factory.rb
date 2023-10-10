module NationalInsurance
  def self.build(person:, optional_space:)
    space = ' ' if optional_space

    [first_name_initial(name: person.first_names),
     surname_initial(name: person.last_name),
     space,
     year_of_birth(dob: person.date_of_birth),
     space,
     random_code_integer(number_of_digits: NiConstants.number_of_random_digits),
     space,
     country_of_birth(country: person.country_of_birth)].join
  end

  def self.first_name_initial(name:)
    if name.include?(". ")
      name.sub(/^\w*\.\s/, '').chars.first.upcase
    else
      name.chars.first.upcase
    end
  end

  def self.surname_initial(name:)
    name.chars.first.upcase
  end

  def self.year_of_birth(dob:)
    Date.parse(dob).strftime(NiConstants.year_format)
  end

  def self.random_code_integer(number_of_digits:)
    number_of_digits.times.map { rand(10) }.join
  end

  def self.country_of_birth(country:)
    if NiConstants.countries_to_count.include? country
      country.chars.first.upcase
    else
      NiConstants.other_country_letter
    end
  end

  def self.add_unique_ni(data:, optional_space:)
    updated_data = []
    check_ni_for_duplicates = Set.new

    data.each do |row|
      unique = true
      repeat_counter = 0
      person = Person.new(person: row)
      person.generate_ni_number(optional_space: optional_space)

      while check_ni_for_duplicates.include?(person.ni_number)
        if repeat_counter < NiConstants.repeat_time_out
          person.generate_ni_number(optional_space: optional_space)
          repeat_counter += 1
        else
          unique = false
          break
        end
      end

      if unique
        check_ni_for_duplicates << person.ni_number
        updated_data << person
      else
        puts ("unable to create unique ni for: #{person.first_names} #{person.last_name}").colorize(:color => :red, :mode => :bold)
      end
    end

    updated_data
  end

  def self.count_ni_countries_of_birth(data:)
    countries_arr = []
    data.each { |person| countries_arr << person.country_of_birth }

    results = {}
    NiConstants.countries_to_count.each { |country| results[country] = countries_arr.count(country) }

    results['Other'] = countries_arr.count - results.values.sum

    puts ("Total number of records counted: #{countries_arr.count}\nTotal Count for each country is as follows:").colorize(:green)

    results.each { |country, total|  puts ("#{country}: #{total}").colorize(:blue)}
  end
end
