# frozen_string_literal: true

require_relative 'file_details'

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
      FileDetails.new(file).create_file_details
    end
  end

  def build_max_width_table
    widths = Hash.new { |h, k| h[k] = [] }
    @file_details.each do |detail|
      widths[:nlink] << detail[:nlink].to_s.length
      widths[:uid_name] << detail[:uid_name].length
      widths[:gid_name] << detail[:gid_name].length
      widths[:size] << detail[:size].to_s.length
    end
    widths.transform_values(&:max)
  end

  def print_file_details(max_width_table)
    file_blocks = @file_details.map { |detail| detail[:block] }.sum
    puts "total #{file_blocks}"
    @file_details.each do |details|
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
