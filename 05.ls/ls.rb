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
  files, parameter_l = find_files
  if parameter_l
    files_details, file_blocks = create_files_details(files)
    files_details_widths = calc_files_details_widths(files_details)
    print_files_details(files_details, files_details_widths, file_blocks)
  else
    column_width = calc_column_width(files)
    row_count = calc_row_count(columns, column_width, files)
    file_name_lines = create_file_name_lines(files, row_count)
    print_file_name_lines(file_name_lines, column_width)
  end
end

def find_files
  opt = OptionParser.new
  opt.on('-l')
  params = {}
  opt.parse!(ARGV, into: params)
  files = Dir.glob('*')
  [files, params[:l]]
end

def create_files_details(files)
  files_details = []
  file_blocks = 0
  files.each do |file|
    fs = File.lstat(file)
    file_blocks += fs.blocks
    file_detail = {}
    file_detail[:ftype] = FILE_TYPE[fs.ftype]
    mode_character = ''
    fs.mode.to_s(8).rjust(6, '0').chars[3..5].each do |mode|
      mode_character += FILE_MODE[mode]
    end
    file_detail[:permission] = mode_character
    file_detail.merge!(nlink: fs.nlink, uid_name: Etc.getpwuid(fs.uid).name, gid_name: Etc.getgrgid(fs.gid).name)
    file_detail.merge!(size: fs.size, month: fs.mtime.month, day: fs.mtime.day, time: fs.mtime.strftime('%R'))
    file_detail[:name] = file
    file_detail[:lname] = File.readlink(file_detail[:name]) if fs.ftype == 'link'
    files_details << file_detail
  end
  [files_details, file_blocks]
end

def calc_files_details_widths(files_details)
  nlinks = []
  uid_names = []
  gid_names = []
  sizes = []
  files_details.each do |details|
    nlinks << details[:nlink]
    uid_names << details[:uid_name]
    gid_names << details[:gid_name]
    sizes << details[:size]
  end
  files_details_widths = {}
  files_details_widths[:nlink] = nlinks.map(&:to_s).max_by(&:length).length
  files_details_widths[:uid_name] = uid_names.max_by(&:length).length
  files_details_widths[:gid_name] = gid_names.max_by(&:length).length
  files_details_widths[:size] = sizes.map(&:to_s).max_by(&:length).length
  files_details_widths
end

def print_files_details(files_details, files_details_widths, file_blocks)
  print 'total ', file_blocks.to_s, "\n"
  files_details.each do |details|
    print details[:ftype]
    print details[:permission]
    print details[:nlink].to_s.rjust(files_details_widths[:nlink] + 2)
    print details[:uid_name].rjust(files_details_widths[:uid_name] + 1)
    print details[:gid_name].rjust(files_details_widths[:gid_name] + 2)
    print details[:size].to_s.rjust(files_details_widths[:size] + 2)
    print details[:month].to_s.rjust(3)
    print details[:day].to_s.rjust(3)
    print details[:time].rjust(6)
    print ' '
    print details[:name].ljust(1)
    if details[:lname]
      print ' -> '
      print details[:lname].ljust(1)
    end
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
