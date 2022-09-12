# frozen_string_literal: true

class Shot
  attr_reader :mark

  def initialize(mark)
    @mark = mark
  end

  def shot_score
    strike? ? 10 : mark.to_i
  end

  def strike?
    mark == 'X'
  end
end
