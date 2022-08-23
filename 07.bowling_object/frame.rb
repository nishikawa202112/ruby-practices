# frozen_string_literal: true

require_relative 'shot'

class Frame
  def initialize(marks)
    @scores = Shot.new(marks).create_scores
  end

  def frame_scores
    @scores.each_slice(2).to_a
  end
end
