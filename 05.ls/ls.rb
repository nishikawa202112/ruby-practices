# frozen_string_literal: true

require 'io/console'

def main
  _, columns = $stdout.winsize
  files = Dir.glob('*')
  column_width = calc_column_width(files)
  column_count, line_count = calc_col_and_row_count(columns, column_width, files)
  names = create_names(files, line_count)
  print_names(names, column_width, column_count, line_count)
end

def calc_column_width(files)
  max_name_length = files.max_by(&:length).length
  column_space = 8 - max_name_length % 8
  max_name_length + column_space
end

def calc_col_and_row_count(columns, column_width, files)
  column_count = columns / column_width
  line_count = (files.size.to_f / column_count).ceil
  [column_count, line_count]
end

def create_names(files, line_count)
  names = []
  names = files.each_slice(line_count).to_a
  (line_count - names.last.size).times { names.last.push(nil) }
  names.transpose
end

def print_names(names, column_width, column_count, line_count)
  line_count.times do |i|
    column_count.times do |n|
      print names[i][n].ljust(column_width) unless names[i][n].nil?
    end
    print("\n")
  end
end

main
