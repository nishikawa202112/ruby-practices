# frozen_string_literal: true

require_relative 'shot'

class Frame
  attr_reader :scores

  def initialize(scores)
    @scores = scores
  end

  def score
    scores.map(&:shot_score).sum
  end

  def strike?
    scores[0].shot_score == 10
  end

  def spare?
    !strike? && score == 10
  end
end
