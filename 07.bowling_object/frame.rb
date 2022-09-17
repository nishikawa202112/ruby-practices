# frozen_string_literal: true

class Frame
  attr_reader :shots
  protected :shots

  def initialize(shots)
    @shots = shots
  end

  def score
    shots.map(&:score).sum
  end

  def strike?
    shots[0].strike? && shots[1].nil?
  end

  def spare?
    !strike? && score == 10
  end

  def calc_score_with_bonus(next_frame, after_next_frame)
    score +
      if strike?
        next_frame.strike? ? (next_frame.score + after_next_frame.shots[0].score) : next_frame.shots[0..1].sum(&:score)
      elsif spare?
        next_frame.shots[0].score
      else
        0
      end
  end

  protected :strike?
  private :spare?
end
