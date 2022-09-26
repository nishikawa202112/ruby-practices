# frozen_string_literal: true

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

class FileDetails
  def initialize(file)
    @file = file
  end

  def create_file_details
    file_detail = {}
    file_detail[:name] = @file
    f_lstat = File.lstat(@file)
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

  private

  def build_permission_text(f_lstat)
    f_lstat
      .mode
      .to_s(8)
      .rjust(6, '0')
      .chars[3..5]
      .map { |mode| FILE_MODE[mode] }
      .join
  end
end
