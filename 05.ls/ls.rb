# frozen_string_literal: true

LINE_COUNT = 3
def main
  files = Dir.glob('*')
  max_name_length = files.max_by { :length }.length
  each_vertical_length = create_vertical_hash(files)
  create_matrix_and_print(files, each_vertical_length, max_name_length)
end

def create_vertical_hash(files)
  vertical_count, vertical_count_remainder = files.size.divmod(LINE_COUNT)
  vertical_lengths = {}
  (1..LINE_COUNT).each { |n| vertical_lengths[n] = vertical_count }
  (1..vertical_count_remainder).each { |n| vertical_lengths[n] += 1 }
  vertical_lengths
end

def create_matrix_and_print(files, each_vertical_lengths, max_name_length)
  matrix = []
  count = 0
  (1..LINE_COUNT).each do |n|
    matrix_column = []
    each_vertical_lengths[n].times do
      matrix_column << files[count]
      count += 1
    end
    matrix.push matrix_column
  end
  (0..each_vertical_lengths[1] - 1).each do |n|
    (0..LINE_COUNT - 1).each do |i|
      print((matrix[i][n]).to_s.ljust(max_name_length + 7))
    end
    print("\n")
  end
end

main
