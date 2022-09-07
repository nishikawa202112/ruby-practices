# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def initialize(game_marks = ARGV[0])
    marks = game_marks.split(',').map { |game_mark| Shot.new(game_mark) }
    frame_scores = []
    one_frame_scores = []
    marks.each do |mark|
      one_frame_scores << mark.score
      next unless (one_frame_scores.length == 2 || mark.score == 10) && frame_scores.length < 9

      frame_scores.push(one_frame_scores)
      one_frame_scores = []
    end
    frame_scores.push(one_frame_scores)
    @frames = frame_scores.map { |scores| Frame.new(scores) }
  end

  def score
    point = (0..8).sum do |i|
      current_frame = @frames[i]
      next_frame = @frames[i + 1]
      next_next_frame = @frames[i + 2]
      if current_frame.strike?
        if next_frame.shots[1].nil?
          current_frame.score + next_frame.score + next_next_frame.shots[0]
        else
          current_frame.score + next_frame.shots[0] + next_frame.shots[1]
        end
      elsif current_frame.spare?
        current_frame.score + next_frame.shots[0]
      else
        current_frame.score
      end
    end
    point + @frames[9].score
  end
end
