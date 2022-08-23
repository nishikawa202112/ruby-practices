# frozen_string_literal: true

require_relative 'frame'

class Game
  def initialize(marks = ARGV[0])
    @marks = marks.split(',')
  end

  def score
    frame_scores = Frame.new(@marks).frame_scores
    calc_point(frame_scores)
  end

  private

  def calc_point(frame_scores)
    point = (0..8).sum do |i|
      if frame_scores[i][0] == 10 && frame_scores[i + 1][0] == 10 # 次のフレームもストライクの時
        20 + frame_scores[i + 2][0]
      elsif frame_scores[i][0] == 10 # ストライク
        10 + frame_scores[i + 1].sum
      elsif frame_scores[i].sum == 10 # スペア
        10 + frame_scores[i + 1][0]
      else
        frame_scores[i].sum
      end
    end
    point += (9..frame_scores.size - 1).sum { |i| frame_scores[i].sum }
    point
  end
end
