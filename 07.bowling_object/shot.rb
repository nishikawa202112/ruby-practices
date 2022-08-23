# frozen_string_literal: true

class Shot
  def initialize(marks)
    @marks = marks
  end

  def create_scores
    scores = []
    @marks.each do |mark|
      if mark == 'X'
        scores.push(10)
        scores.push(0)
      else
        scores.push(mark.to_i)
      end
    end
    scores
  end
end
