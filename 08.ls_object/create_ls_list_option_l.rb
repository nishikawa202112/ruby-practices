# frozen_string_literal: true

require_relative 'file_detail'

class CreateLsListOptionL
  def initialize(files)
    @file_details = create_file_details(files)
  end

  def print_ls
    max_width_table = build_max_width_table
    print_file_details(max_width_table)
  end

  private

  def create_file_details(files)
    files.map do |file|
      FileDetail.new(file)
    end
  end

  def build_max_width_table
    widths = Hash.new { |h, k| h[k] = [] }
    @file_details.each do |detail|
      widths[:nlink] << detail.nlink.to_s.length
      widths[:uid_name] << detail.uid_name.length
      widths[:gid_name] << detail.gid_name.length
      widths[:size] << detail.size.to_s.length
    end
    widths.transform_values(&:max)
  end

  def print_file_details(max_width_table)
    file_blocks = @file_details.map(&:block).sum
    puts "total #{file_blocks}"
    @file_details.each do |detail|
      print detail.ftype
      print detail.permission
      print detail.nlink.to_s.rjust(max_width_table[:nlink] + 2)
      print detail.uid_name.rjust(max_width_table[:uid_name] + 1)
      print detail.gid_name.rjust(max_width_table[:gid_name] + 2)
      print detail.size.to_s.rjust(max_width_table[:size] + 2)
      print detail.times
      print detail.name
      print " -> #{detail.lname}" if detail.lname
      print "\n"
    end
  end
end
