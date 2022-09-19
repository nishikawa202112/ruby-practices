# frozen_string_literal: true

require 'io/console'
require 'etc'

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

class LsL
  def initialize(files)
    @file_details = create_file_details(files)
  end

  def print_ls
    max_width_table = build_max_width_table(@file_details)
    print_file_details(@file_details, max_width_table)
  end

  private

  def create_file_details(files)
    files.map do |file|
      file_detail = {}
      file_detail[:name] = file
      f_lstat = File.lstat(file)
      file_detail[:block] = f_lstat.blocks
      file_detail[:ftype] = FILE_TYPE[f_lstat.ftype]
      file_detail[:permission] = build_permission_text(f_lstat)
      file_detail[:nlink] = f_lstat.nlink
      file_detail[:uid_name] = Etc.getpwuid(f_lstat.uid).name
      file_detail[:gid_name] = Etc.getgrgid(f_lstat.gid).name
      file_detail[:size] = f_lstat.size
      file_detail[:times] = f_lstat.mtime.strftime('%_3m%_3d%_6R ')
      file_detail[:lname] = File.readlink(file_detail[:name]) if f_lstat.ftype == 'link'
      file_detail
    end
  end

  def build_permission_text(f_lstat)
    f_lstat
      .mode
      .to_s(8)
      .rjust(6, '0')
      .chars[3..5]
      .map { |mode| FILE_MODE[mode] }
      .join
  end

  def build_max_width_table(file_details)
    widths = Hash.new { |h, k| h[k] = [] }
    file_details.each do |detail|
      widths[:nlink] << detail[:nlink].to_s.length
      widths[:uid_name] << detail[:uid_name].length
      widths[:gid_name] << detail[:gid_name].length
      widths[:size] << detail[:size].to_s.length
    end
    widths.transform_values(&:max)
  end

  def print_file_details(file_details, max_width_table)
    file_blocks = file_details.map { |detail| detail[:block] }.sum
    puts "total #{file_blocks}"
    file_details.each do |details|
      print details[:ftype]
      print details[:permission]
      print details[:nlink].to_s.rjust(max_width_table[:nlink] + 2)
      print details[:uid_name].rjust(max_width_table[:uid_name] + 1)
      print details[:gid_name].rjust(max_width_table[:gid_name] + 2)
      print details[:size].to_s.rjust(max_width_table[:size] + 2)
      print details[:times]
      print details[:name]
      print " -> #{details[:lname]}" if details[:lname]
      print "\n"
    end
  end
end
