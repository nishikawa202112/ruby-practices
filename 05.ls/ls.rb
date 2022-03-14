# frozen_string_literal: true

require 'io/console'

TAB_SPACE = 8
def main
  _, columns = $stdout.winsize
  files = Dir.glob('*')
  column_width = calc_column_width(files)
  line_count = calc_row_count(columns, column_width, files)
  names = create_names(files, line_count)
  print_names(names, column_width)
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

def create_names(files, line_count)
  names = files.each_slice(line_count).to_a
  (line_count - names.last.size).times { names.last.push(nil) }
  names.transpose
end

def print_names(names, column_width)
  names.each do |line|
    line.each do |name|
      print name.ljust(column_width) unless name.nil?
    end
    print("\n")
  end
end

main
