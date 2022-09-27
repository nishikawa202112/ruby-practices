# frozen_string_literal: true

require 'etc'

class FileDetail
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

  def initialize(file)
    @file = file
    @f_lstat = File.lstat(@file)
  end

  def name
    @file
  end

  def block
    @f_lstat.blocks
  end

  def ftype
    FILE_TYPE[@f_lstat.ftype]
  end

  def permission
    build_permission_text
  end

  def nlink
    @f_lstat.nlink
  end

  def uid_name
    Etc.getpwuid(@f_lstat.uid).name
  end

  def gid_name
    Etc.getgrgid(@f_lstat.gid).name
  end

  def size
    @f_lstat.size
  end

  def times
    @f_lstat.mtime.strftime('%_3m%_3d%_6R ')
  end

  def lname
    File.readlink(@file) if @f_lstat.ftype == 'link'
  end

  private

  def build_permission_text
    @f_lstat
      .mode
      .to_s(8)
      .rjust(6, '0')
      .chars[3..5]
      .map { |mode| FILE_MODE[mode] }
      .join
  end
end
