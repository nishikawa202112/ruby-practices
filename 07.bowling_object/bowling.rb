# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

def main
  puts Game.new.total_score
end

class Game
  def initialize(mark_text = ARGV[0])
    shots = mark_text.split(',').map { |mark| Shot.new(mark) }
    frame_scores = []
    one_frame_scores = []
    shots.each do |shot|
      one_frame_scores << shot
      next unless (one_frame_scores.length == 2 || shot.shot_score == 10) && frame_scores.length < 9

      frame_scores.push(one_frame_scores)
      one_frame_scores = []
    end
    frame_scores.push(one_frame_scores)
    @frames = frame_scores.map { |scores| Frame.new(scores) }
  end

  def total_score
    point = (0..8).sum do |i|
      current_frame = @frames[i]
      next_frame = @frames[i + 1]
      next_next_frame = @frames[i + 2]
      if current_frame.strike?
        if next_frame.strike? && (i != 8)
          current_frame.score + next_frame.score + next_next_frame.scores[0].shot_score
        else
          current_frame.score + next_frame.scores[0].shot_score + next_frame.scores[1].shot_score
        end
      elsif current_frame.spare?
        current_frame.score + next_frame.scores[0].shot_score
      else
        current_frame.score
      end
    end
    point + @frames[9].score
  end
end

main
