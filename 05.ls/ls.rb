# frozen_string_literal: true

require 'io/console'

TAB_SPACE = 8

def main
  _, columns = $stdout.winsize
  files = Dir.glob('*')
  column_width = calc_column_width(files)
  row_count = calc_row_count(columns, column_width, files)
  file_name_lines = create_file_name_lines(files, row_count)
  print_file_name_lines(file_name_lines, column_width)
end

def calc_column_width(files)
  max_name_length = files.max_by(&:length).length
  column_space = TAB_SPACE - max_name_length % TAB_SPACE
  max_name_length + column_space
end

def calc_row_count(columns, column_width, files)
  column_count = columns / column_width
  (files.size.to_f / column_count).ceil
end

def create_file_name_lines(files, row_count)
  file_name_lines = files.each_slice(row_count).to_a
  (row_count - file_name_lines.last.size).times { file_name_lines.last.push(nil) }
  file_name_lines.transpose
end

def print_file_name_lines(file_name_lines, column_width)
  file_name_lines.each do |line|
    line.each do |name|
      print name.ljust(column_width) unless name.nil?
    end
    print "\n"
  end
end

main
