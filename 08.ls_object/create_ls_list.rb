# frozen_string_literal: true

require 'io/console'

TAB_SPACE = 8

class CreateLsList
  def initialize(files)
    @files = files
  end

  def print_ls
    column_width = calc_column_width
    row_count = calc_row_count(column_width)
    file_name_lines = create_file_name_lines(row_count)
    print_file_name_lines(file_name_lines, column_width)
  end

  private

  def calc_column_width
    max_name_length = @files.max_by(&:length).length
    column_space = TAB_SPACE - max_name_length % TAB_SPACE
    max_name_length + column_space
  end

  def calc_row_count(column_width)
    _, columns = $stdout.winsize
    column_count = columns / column_width
    (@files.size.to_f / column_count).ceil
  end

  def create_file_name_lines(row_count)
    file_name_lines = @files.each_slice(row_count).to_a
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
end
