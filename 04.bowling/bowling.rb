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
frames = []
scores.each_slice(2) do |s|
  frames.push(s)
end

# 点数を計算する
point = 0
(0..8).each do |i|
  if frames[i][0] == 10 # ストライク
    point += 10 + frames[i + 1].sum
    point += frames[i + 2][0] if frames[i + 1][0] == 10
  elsif frames[i].sum == 10 # スペア
    point += 10 + frames[i + 1][0]
  else
    point += frames[i].sum
  end
end

(9..frames.size - 1).each do |i|
  point += frames[i].sum
end

# 点数を表示する
puts point
