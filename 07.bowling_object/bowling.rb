# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def self.run(mark_text)
    puts new(mark_text).total_score
  end

  def initialize(mark_text)
    shots = []
    @frames = []
    mark_text.split(',').each do |mark|
      shot = Shot.new(mark)
      shots << shot
      next unless (shots.length == 2 || shot.strike?) && @frames.length < 9

      @frames.push(Frame.new(shots))
      shots = []
    end
    @frames.push(Frame.new(shots))
  end

  def total_score
    score = (0..8).sum do |i|
      current_frame = @frames[i]
      next_frame = @frames[i + 1]
      after_next_frame = @frames[i + 2]
      current_frame.calc_score_with_bonus(next_frame, after_next_frame)
    end
    score + @frames[9].score
  end
end

Game.run(ARGV[0])
