module NationalInsurance
  def self.build(person:, optional_space:)
    if optional_space
      space = ' '
    end

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
    Date.parse(dob).strftime('%y')
  end

  def self.random_code_integer(number_of_digits:)
    number_of_digits.times.map { rand(10) }.join
  end

  def self.country_of_birth(country:)
    if NI_Constants.countries_to_count.include? country
      country.chars.first.upcase
    else
      %w(O)
    end
  end

  def self.unique_ni_checker(ni_list:)
    check_ni = Set.new
    duplicate_ni_numbers = ni_list.select { |e| !check_ni.add?(e.ni_number) }

    if duplicate_ni_numbers.count > 0
      puts "#{duplicate_ni_numbers.count} Duplicated NI numbers found, regenerating ni numbers for duplicates\n\n"
      regenerate_ni(ni_list: ni_list, duplicate_ni_numbers: duplicate_ni_numbers)
    else
      ni_list
    end
  end

  def self.regenerate_ni(ni_list:, duplicate_ni_numbers:)
    updated_list = ni_list - duplicate_ni_numbers
    duplicate_ni_numbers.each do |person|
      # while look ensure no further duplicates are added into the array
      person.generate_ni_number while updated_list.include?(person.ni_number)
      updated_list << person
    end
    updated_list
  end

  def self.count_ni_country_of_birth(ni_list:)
    countries_arr = []
    ni_list.each do |object|
      countries_arr << object.country_of_birth
    end

    results = {}
    NI_Constants.countries_to_count.each do |country|
      results[country] = countries_arr.count(country)
    end
    # calculate other countries
    results['Other'] = countries_arr.count - results.values.sum

    # output Results
    puts ("Total number of records counted: #{countries_arr.count}\nTotal Count for each country is as follows:").colorize(:green)
    results.each do |key, value|
      puts ("#{key}: #{value}").colorize(:blue)
    end
  end
end
