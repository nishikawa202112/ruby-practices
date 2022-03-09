# frozen_string_literal: true

require 'io/console'

def main
  _, colums = $stdout.winsize
  files = Dir.glob('*')
  max_name_length = files.max_by { :length }.length + 2
  line_count = colums / max_name_length
  vertical_length, remainder = files.size.divmod(line_count)
  vertical_length += 1 if remainder.positive?
  names = create_array(files, vertical_length, line_count)
  print_array(names, max_name_length, line_count, vertical_length)
end

def create_array(files, vertical_length, line_count)
  names_array = []
  count = 0
  line_count.times do
    name_array = []
    vertical_length.times do
      if count == files.size
        name_array << ' '
      else
        name_array << files[count]
        count += 1
      end
    end
    names_array << name_array
  end
  names_array.transpose
end

def print_array(names, max_name_length, line_count, vertical_length)
  (0..vertical_length - 1).each do |i|
    (0..line_count - 1).each do |n|
      print names[i][n].ljust(max_name_length)
    end
    print("\n")
  end
end

main
