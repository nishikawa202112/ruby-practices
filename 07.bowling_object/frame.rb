# frozen_string_literal: true

class Frame
  attr_reader :shots

  def initialize(shots = nil)
    @shots = shots
  end

  def score
    shots.map(&:to_i).sum
  end

  def strike?
    shots[0] == 10
  end

  def spare?
    !strike? && score == 10
  end
end
