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
  long_format = find_long_format
  if long_format
    files_details = create_files_details(files)
    files_details_widths = calc_files_details_widths(files_details)
    print_files_details(files_details, files_details_widths)
  else
    column_width = calc_column_width(files)
    row_count = calc_row_count(columns, column_width, files)
    file_name_lines = create_file_name_lines(files, row_count)
    print_file_name_lines(file_name_lines, column_width)
  end
end

def find_long_format
  opt = OptionParser.new
  opt.on('-l')
  params = {}
  opt.parse!(ARGV, into: params)
  params[:l]
end

def create_files_details(files)
  files_details = []
  files.each do |file|
    f_lstat = File.lstat(file)
    file_detail = {}
    file_detail[:block] = f_lstat.blocks
    file_detail[:ftype] = FILE_TYPE[f_lstat.ftype]
    file_detail[:permission] = find_permission(f_lstat)
    file_detail[:nlink] = f_lstat.nlink
    file_detail[:uid_name] = Etc.getpwuid(f_lstat.uid).name
    file_detail[:gid_name] = Etc.getgrgid(f_lstat.gid).name
    file_detail[:size] = f_lstat.size
    file_detail[:times] = f_lstat.mtime.strftime('%_3m%_3d %_6R ')
    file_detail[:name] = file
    file_detail[:lname] = File.readlink(file_detail[:name]) if f_lstat.ftype == 'link'
    files_details << file_detail
  end
  files_details
end

def find_permission(f_lstat)
  mode_character = ''
  f_lstat.mode.to_s(8).rjust(6, '0').chars[3..5].each do |mode|
    mode_character += FILE_MODE[mode]
  end
  mode_character
end

def calc_files_details_widths(files_details)
  lengths = Hash.new { |h, k| h[k] = [] }
  files_details.each do |details|
    lengths[:nlink] << details[:nlink].to_s.length
    lengths[:uid_name] << details[:uid_name].length
    lengths[:gid_name] << details[:gid_name].length
    lengths[:size] << details[:size].to_s.length
  end
  lengths.transform_values(&:max)
end

def print_files_details(files_details, files_details_widths)
  file_blocks = calc_file_blocks(files_details)
  puts "total #{file_blocks}"
  files_details.each do |details|
    print details[:ftype]
    print details[:permission]
    print details[:nlink].to_s.rjust(files_details_widths[:nlink] + 2)
    print details[:uid_name].rjust(files_details_widths[:uid_name] + 1)
    print details[:gid_name].rjust(files_details_widths[:gid_name] + 2)
    print details[:size].to_s.rjust(files_details_widths[:size] + 2)
    print details[:times]
    print details[:name]
    print " -> #{details[:lname]}" if details[:lname]
    print "\n"
  end
end

def calc_file_blocks(files_details)
  file_blocks = 0
  files_details.each do |details|
    file_blocks += details[:block]
  end
  file_blocks
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
