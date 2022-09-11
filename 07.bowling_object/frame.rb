# frozen_string_literal: true

class Frame
  attr_reader :frame_shots

  def initialize(frame_shots)
    @frame_shots = frame_shots
  end

  def score
    frame_shots.map(&:shot_score).sum
  end

  def strike?
    frame_shots[0].strike?
  end

  def spare?
    !strike? && score == 10
  end
end
