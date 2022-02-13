# frozen_string_literal: true

score = ARGV[0].split(',')

# x(ストライク)を10,0にして整数の配列を作る
scores = []
score.each do |s|
  if s == 'x'
    scores.push(10)
    scores.push(0)
  else
    scores.push(s.to_i)
  end
end

# フレームごとに分ける
frames = scores.each_slice(2).to_a

# 点数を計算する
point = (0..8).sum do |i|
  if frames[i][0] == 10 && frames[i + 1][0] == 10 # 次のフレームもストライクの時
    20 + frames[i + 2][0]
  elsif frames[i][0] == 10 # ストライク
    10 + frames[i + 1].sum
  elsif frames[i].sum == 10 # スペア
    10 + frames[i + 1][0]
  else
    frames[i].sum
  end
end

point += (9..frames.size - 1).sum { |i| frames[i].sum }

# 点数を表示する
puts point
