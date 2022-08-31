# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(games_mark = ARGV[0])
    marks = games_mark.split(',')
    frame_scores = []
    frame_score = []
    frame_number = 0
    marks.each do |mark|
      frame_score <<  mark
      next unless (frame_score.length == 2 || frame_score[0] == 'X') && frame_number < 9

      frame_scores.push(frame_score)
      frame_number += 1
      frame_score = []
    end
    frame_scores.push(frame_score)
    @frames = []
    frame_scores.each_with_index do |score, i|
      @frames[i] = Frame.new(score[0], score[1], score[2])
    end
  end

  def score
    point = (0..8).sum do |i|
      if @frames[i].first_shot.mark == 'X' && @frames[i + 1].first_shot.mark == 'X'
        i == 8 ? 20 + @frames[9].second_shot.score : 20 + @frames[i + 2].first_shot.score
      elsif @frames[i].first_shot.mark == 'X'
        10 + @frames[i + 1].first_shot.score + @frames[i + 1].second_shot.score
      elsif @frames[i].frame_score == 10
        10 + @frames[i + 1].first_shot.score
      else
        @frames[i].frame_score
      end
    end
    point + @frames[9].frame_score
  end
end
