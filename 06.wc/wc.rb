# frozen_string_literal: true

require 'optparse'

def main
  params = ARGV.getopts('l')
  file_names = ARGV
  files = find_files(file_names)
  file_data = create_file_data(files, file_names)
  print_file_data(file_data, params)
end

def find_files(file_names)
  if file_names == []
    file = $stdin.readlines
    files = []
    files << file
  else
    files = file_names.map { |file_name| File.new(file_name).readlines }
  end
  files
end

def create_file_data(files, file_names)
  file_data =
    files.map do |file|
      file_data = {}
      file_data[:line] = file.map { |lines| lines.count("\n") }.sum
      file_data[:word] = file.map { |lines| lines.split.count }.sum
      file_data[:size] = file.map(&:bytesize).sum
      file_data
    end
  count = 0
  file_data.each do |data|
    data[:name] = file_names[count]
    count += 1
  end
  file_data << calc_total(file_data) if file_names.any?
  file_data
end

def calc_total(file_data)
  total_data = {}
  total_data[:line] = file_data.map { |data| data[:line] }.sum
  total_data[:word] = file_data.map { |data| data[:word] }.sum
  total_data[:size] = file_data.map { |data| data[:size] }.sum
  total_data[:name] = 'total'
  total_data
end

def print_file_data(file_data, params)
  file_data.each do |data|
    print data[:line].to_s.rjust(8)
    print data[:word].to_s.rjust(8) unless params['l']
    print data[:size].to_s.rjust(8) unless params['l']
    print " #{data[:name]}" if data[:name]
    print "\n"
  end
end

main
