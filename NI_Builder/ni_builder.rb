require 'colorize'
require 'csv'
require 'date'
require 'set'

require_relative 'data/file_constants'
require_relative 'data/ni_constants'
require_relative 'support/file_helper'
require_relative 'support/ni_factory'
require_relative 'support/person'

def build_ni_from_csv(file_name:, save_file_name:, optional_space: false)
  people = File_helper.read_csv(file_name: file_name)

  # create unique ni numbers for given list
  unique_ni_list = NationalInsurance.add_unique_ni(list: people, optional_space: optional_space)

  # call method to output country of birth high level count
  NationalInsurance.count_ni_country_of_births(ni_list: unique_ni_list)

  # save list to csv
  File_helper.save_to_csv(save_file_name: save_file_name, data: unique_ni_list)
end


build_ni_from_csv(file_name: 'NI_Builder/data/data_set.csv', save_file_name: 'save1')
# build_ni_from_csv(file_name: 'NI_Builder/data/data_set.csv', save_file_name: 'save1', optional_space: false)
# build_ni_from_csv(file_name: 'NI_Builder/data/data_set.csv', save_file_name: 'save1', optional_space: true)