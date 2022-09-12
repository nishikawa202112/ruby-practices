# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def self.run
    puts new.total_score
  end

  def initialize(mark_text = ARGV[0])
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
    point = (0..8).sum do |i|
      current_frame = @frames[i]
      next_frame = @frames[i + 1]
      after_next_frame = @frames[i + 2]
      current_frame.score +
        if current_frame.strike?
          next_frame.shots[1].nil? ? next_frame.score + after_next_frame.shots[0].shot_score : next_frame.shots[0..1].sum(&:shot_score)
        elsif current_frame.spare?
          next_frame.shots[0].shot_score
        else
          0
        end
    end
    point + @frames[9].score
  end
end

Game.run
