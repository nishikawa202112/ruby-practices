require 'optparse'
require 'date'

opt = OptionParser.new
params = {}

opt.on('-y [val]','--year [val]'){|v| params[:y] = v}
opt.on('-m [val]','--month [val]'){|v| params[:m] = v}
begin
  opt.parse!(ARGV)  
rescue OptionParser::InvalidOption=> exception
  puts "#{exception.message}"
end

#西暦を確定する
if params[:y] == nil       
  year = Date.today.year
else
  year = params[:y].to_i  
end

#月を確定する     
if params[:m] == nil       
  month = Date.today.month
else
  month = params[:m].to_i
end

#カレンダーの月末の日付を取得する
last_day = Date.new(year, month, -1).day

#カレンダーを表示する
print("      #{month}月 #{year}\n")
print("日 月 火 水 木 金 土\n")

count = Date.new(year, month, 1).wday
count.times do
  print("   ")
end

(1..last_day).each do |day|
  print("\n")  if count % 7 == 0  
  if Date.new(year, month, day) == Date.today
    print("\e[7m"+" #{day}".rjust(2)+"\e[0m"+" ") 
  else
    print("#{day}".rjust(2)+" ")
  end
  count += 1
end