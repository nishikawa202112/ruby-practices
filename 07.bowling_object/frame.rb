# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots)
    @shots = shots
  end

  def score
    shots.map(&:score).sum
  end

  def strike?
    shots[0].strike?
  end

  def spare?
    !strike? && score == 10
  end
end
