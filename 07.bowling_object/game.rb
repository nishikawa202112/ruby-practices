# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(games_marks = ARGV[0])
    marks = games_marks.split(',').map { |games_mark| Shot.new(games_mark) }
    frame_scores = []
    one_frame_scores = []
    frame_number = 0
    marks.each do |mark|
      one_frame_scores << mark.score
      next unless (one_frame_scores.length == 2 || mark.score == 10) && frame_number < 9

      frame_scores.push(one_frame_scores)
      frame_number += 1
      one_frame_scores = []
    end
    frame_scores.push(one_frame_scores)
    @frames = []
    @frames = frame_scores.map { |scores| Frame.new(scores[0], scores[1], scores[2]) }
  end

  def score
    point = (0..8).sum do |i|
      if @frames[i].strike
        if @frames[i + 1].second_shot.nil?
          @frames[i].score + @frames[i + 1].score + @frames[i + 2].first_shot
        else
          @frames[i].score + @frames[i + 1].first_shot + @frames[i + 1].second_shot
        end
      elsif @frames[i].spare
        @frames[i].score + @frames[i + 1].first_shot
      else
        @frames[i].score
      end
    end
    point + @frames[9].score
  end
end
