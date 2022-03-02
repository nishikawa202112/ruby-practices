# frozen_string_literal: true

def main
  files = Dir.glob('*').sort
  name_maxlength = files[0].length
  (1..files.size - 1).each do |n|
    length = files[n].length
    name_maxlength = length if name_maxlength < length
  end
  line_count = 3
  each_vertical_length = create_vertical_hash(line_count, files)
  create_matrix_and_print(line_count, files, each_vertical_length, name_maxlength)
end

def create_vertical_hash(line_count, files)
  vertical_count = files.size / line_count
  vertical_count_remainder = files.size % line_count
  vertical_lengths = {}
  (1..line_count).each { |n| vertical_lengths[n] = vertical_count }
  (1..vertical_count_remainder).each { |n| vertical_lengths[n] += 1 }
  vertical_lengths
end

def create_matrix_and_print(line_count, files, each_vertical_lengths, name_maxlength)
  matrix = []
  count = 0
  (1..line_count).each do |n|
    matrix_column = []
    each_vertical_lengths[n].times do
      matrix_column << files[count]
      count += 1
    end
    matrix.push matrix_column
  end
  (0..each_vertical_lengths[1] - 1).each do |n|
    (0..line_count - 1).each do |i|
      print((matrix[i][n]).to_s.ljust(name_maxlength + 7))
    end
    print("\n")
  end
end

main
