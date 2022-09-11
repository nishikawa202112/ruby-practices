# frozen_string_literal: true

require_relative 'shot'
require_relative 'frame'

class Game
  def self.run
    puts new.total_score
  end

  def initialize(mark_text = ARGV[0])
    shots = mark_text.split(',').map { |mark| Shot.new(mark) }
    all_frames_shots = []
    one_frame_shots = []
    shots.each do |shot|
      one_frame_shots << shot
      next unless (one_frame_shots.length == 2 || shot.strike?) && all_frames_shots.length < 9

      all_frames_shots.push(one_frame_shots)
      one_frame_shots = []
    end
    all_frames_shots.push(one_frame_shots)
    @frames = all_frames_shots.map { |frame_shots| Frame.new(frame_shots) }
  end

  def total_score
    point = (0..8).sum do |i|
      current_frame = @frames[i]
      next_frame = @frames[i + 1]
      after_next_frame = @frames[i + 2]
      if current_frame.strike?
        if next_frame.strike? && (i != 8)
          current_frame.score + next_frame.score + after_next_frame.frame_shots[0].shot_score
        else
          current_frame.score + next_frame.frame_shots[0].shot_score + next_frame.frame_shots[1].shot_score
        end
      elsif current_frame.spare?
        current_frame.score + next_frame.frame_shots[0].shot_score
      else
        current_frame.score
      end
    end
    point + @frames[9].score
  end
end

Game.run
