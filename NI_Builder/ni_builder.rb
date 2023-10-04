require 'csv'
require 'date'
require 'set'
require 'colorize'
require_relative 'support/file_helper'
require_relative 'support/person'
require_relative 'support/ni_factory'
require_relative 'data/ni_constants'
require_relative 'data/file_constants'

def build_ni(file_name:, save_file_name:, optional_space: false)
  people = File_helper.read_csv(file_name: file_name)
  temp_ni_list = []

  # creates temporary list which may contain duplicate ids
  people.each do |row|
    person = Person.new(person: row)
    person.generate_ni_number(optional_space: optional_space)
    temp_ni_list << person
  end

  # pass temp list to method to check for duplicated values and regenerate ni if needed
  unique_ni_list = NationalInsurance.unique_ni_checker(ni_list: temp_ni_list)

  # call method to output country of birth high level count
  NationalInsurance.count_ni_country_of_birth(ni_list: unique_ni_list)

  # save to csv
  File_helper.save_to_csv(save_file_name: save_file_name, data: unique_ni_list)
end


build_ni(file_name: 'NI_Builder/data/data_set.csv', save_file_name: 'save1')
# build_ni(file_name: 'NI_Builder/data/data_set.csv', save_file_name: 'save1', optional_space: false)
# build_ni(file_name: 'NI_Builder/data/data_set.csv', save_file_name: 'save1', optional_space: true)