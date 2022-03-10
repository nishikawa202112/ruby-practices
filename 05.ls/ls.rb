# frozen_string_literal: true

require 'io/console'

def main
  _, columns = $stdout.winsize
  files = Dir.glob('*')
  max_name_length = create_max_name_length(files)
  column_count, line_count = seek_column_and_line(columns, max_name_length, files)
  names = create_names(files, line_count, column_count)
  print_names(names, max_name_length, column_count, line_count)
end

def create_max_name_length(files)
  max_name_length = files.max_by(&:length).length
  column_space = 8 - max_name_length % 8
  max_name_length + column_space
end

def seek_column_and_line(columns, max_name_length, files)
  column_count = columns / max_name_length
  line_count = (files.size.to_f / column_count).ceil
  [column_count, line_count]
end

def create_names(files, line_count, column_count)
  names = []
  count = 0
  column_count.times do
    names_array = []
    line_count.times do
      if count == files.size
        names_array << ' '
      else
        names_array << files[count]
        count += 1
      end
    end
    names << names_array
  end
  names.transpose
end

def print_names(names, max_name_length, column_count, line_count)
  (0..line_count - 1).each do |i|
    (0..column_count - 1).each do |n|
      print names[i][n].ljust(max_name_length) unless names[i][n] == ' '
    end
    print("\n")
  end
end

main
