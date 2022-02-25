# frozen_string_literal: true

class File
  attr_reader :name

  def initialize(name)
    @name = name
  end
end

class Formatter
  attr_reader :max, :maxlength, :files, :line, :index

  def file_name_length(files)
    @files = files
    @max = files.size
    @maxlength = files[0].name.length
    (1..@max - 1).each do |n|
      @maxlength = files[n].name.length if @maxlength < files[n].name.length
    end
  end

  def file_format(line)
    @line = line # 列の数
    count1 = @max / line
    count2 = @max % line
    index = {}
    (1..line).each { |n| index[n] = count1 }
    (1..count2).each { |n| index[n] += 1 }
    @index = index # 縦の長さ
  end

  def set_and_print
    cell = []
    count = 0
    (1..@line).each do |n|
      cell_x = []
      @index[n].times do
        cell_x << @files[count].name
        count += 1
      end
      cell.push cell_x
    end
    (0..@index[1] - 1).each do |n|
      (0..@line - 1).each do |i|
        print((cell[i][n]).to_s.ljust(@maxlength + 7))
      end
      print("\n")
    end
  end
end

dir_file = Dir.glob('*').sort
files = dir_file.map { |n| File.new(n) }
formatter = Formatter.new
formatter.file_name_length(files)
line = 3
formatter.file_format(line)
formatter.set_and_print
