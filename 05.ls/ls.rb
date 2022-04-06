# frozen_string_literal: true

require 'io/console'
require 'optparse'
require 'etc'

TAB_SPACE = 8

FILE_TYPE = {
  'file' => '-',
  'directory' => 'd',
  'link' => 'l'
}.freeze

FILE_MODE = {
  '0' => '---',
  '1' => '--x',
  '2' => '-w-',
  '3' => '-wx',
  '4' => 'r--',
  '5' => 'r-x',
  '6' => 'rw-',
  '7' => 'rwx'
}.freeze

def main
  _, columns = $stdout.winsize
  files = Dir.glob('*')
  if long_format?
    file_details = create_file_details(files)
    file_details_widths = calc_file_details_widths(file_details)
    print_file_details(file_details, file_details_widths)
  else
    column_width = calc_column_width(files)
    row_count = calc_row_count(columns, column_width, files)
    file_name_lines = create_file_name_lines(files, row_count)
    print_file_name_lines(file_name_lines, column_width)
  end
end

def long_format?
  opt = OptionParser.new
  opt.on('-l')
  params = {}
  opt.parse!(ARGV, into: params)
  params[:l]
end

def create_file_details(files)
  files.map do |file|
    f_lstat = File.lstat(file)
    name = file
    file = {}
    file[:block] = f_lstat.blocks
    file[:ftype] = FILE_TYPE[f_lstat.ftype]
    file[:permission] = find_permission(f_lstat)
    file[:nlink] = f_lstat.nlink
    file[:uid_name] = Etc.getpwuid(f_lstat.uid).name
    file[:gid_name] = Etc.getgrgid(f_lstat.gid).name
    file[:size] = f_lstat.size
    file[:times] = f_lstat.mtime.strftime('%_3m%_3d %_6R ')
    file[:name] = name
    file[:lname] = File.readlink(file[:name]) if f_lstat.ftype == 'link'
    file
  end
end

def find_permission(f_lstat)
  f_lstat
    .mode
    .to_s(8)
    .rjust(6, '0')
    .chars[3..5]
    .map { |mode| FILE_MODE[mode] }
    .join
end

def calc_file_details_widths(file_details)
  widths = Hash.new { |h, k| h[k] = [] }
  file_details.each do |detail|
    widths[:nlink] << detail[:nlink].to_s.length
    widths[:uid_name] << detail[:uid_name].length
    widths[:gid_name] << detail[:gid_name].length
    widths[:size] << detail[:size].to_s.length
  end
  widths.transform_values(&:max)
end

def print_file_details(file_details, file_details_widths)
  file_blocks = file_details.map { |detail| detail[:block] }.sum
  puts "total #{file_blocks}"
  file_details.each do |details|
    print details[:ftype]
    print details[:permission]
    print details[:nlink].to_s.rjust(file_details_widths[:nlink] + 2)
    print details[:uid_name].rjust(file_details_widths[:uid_name] + 1)
    print details[:gid_name].rjust(file_details_widths[:gid_name] + 2)
    print details[:size].to_s.rjust(file_details_widths[:size] + 2)
    print details[:times]
    print details[:name]
    print " -> #{details[:lname]}" if details[:lname]
    print "\n"
  end
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
