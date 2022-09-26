# frozen_string_literal: true

require 'io/console'
require 'optparse'
require_relative 'create_ls_list_option_l'
require_relative 'create_ls_list'

class Ls
  def initialize(argv_params)
    @params = parse_params(argv_params)
    @files = find_files
  end

  def print_ls
    if @params[:l]
      CreateLsListOptionL.new(@files).print_ls
    else
      CreateLsList.new(@files).print_ls
    end
  end

  private

  def parse_params(argv_params)
    opt = OptionParser.new
    opt.on('-a')
    opt.on('-r')
    opt.on('-l')
    params = {}
    opt.parse!(argv_params, into: params)
    params
  end

  def find_files
    files = @params[:a] ? Dir.entries('.').sort : Dir.glob('*')
    @params[:r] ? files.reverse : files
  end
end

Ls.new(ARGV).print_ls