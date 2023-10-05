module File_helper
  def self.read_csv(file_name:)
    begin
      CSV.parse(File.read(file_name), headers: true).map(&:to_h)
    rescue Errno::ENOENT => e
      raise ("Unable to find csv file to load:\n#{e}").colorize(:color => :red, :mode => :bold)
    end
  end

  def self.save_to_csv(save_file_name:, data:)
    string_arr = transform_object_to_array(data: data)
    begin
      CSV.open("Results/#{save_file_name}.csv", 'w', write_headers: true, headers: File_constants.file_headers) do |line|
        string_arr.each { |person| line << person }
      end
    rescue Errno::ENOENT => e
      raise ("Unable to save csv file:\n#{e}").colorize(:color => :red, :mode => :bold)
    else
      puts ("File: #{save_file_name} has been saved in Results directory").colorize(:green)
    end
  end

  def self.transform_object_to_array(data:)
    string_arr = []
    data.map { |person| string_arr << person.convert_to_arr}
    string_arr
  end
end
