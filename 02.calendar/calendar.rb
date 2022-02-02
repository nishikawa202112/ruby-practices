require 'optparse'
require 'date'

@d = Date.today       #今日の日付を取得

opt = OptionParser.new
params = {}

def year_hantei(nen)    #西暦の入力内容を確認して補正する
  unless nen >= 1970 && nen <=2100
    if @year_nil_flag == 0      #西暦を指定していた(nillでない)場合
      puts "計算範囲外のため今年の西暦で表示します。"
    end
    nen = @d.year
  end 
  return nen
end

def month_hantei(gatu)     #月の入力内容を確認して補正する
  unless gatu >=1 && gatu <=12  
    if @month_nil_flag ==0     #月を指定していた(nillでない)場合
      puts '計算範囲外のため今月と同じ"月"で表示します。'
    end
    gatu = @d.month
  end
  return gatu
end


#コマンドラインから取得
opt.on('-y [val]','--year [val]'){|v| params[:y] = v}
opt.on('-m [val]','--month [val]'){|v| params[:m] = v}
begin
  opt.parse!(ARGV)  
rescue OptionParser::InvalidOption=> exception
  puts "#{exception.message}"
end


#西暦を確定する
@year_nil_flag = 0
if params[:y] == nil       #西暦を指定しなかったときフラグ=１
  @year_nil_flag = 1
end
seireki = year_hantei(params[:y].to_i)  #西暦をseirekiにセット

#月を確定する
@month_nil_flag = 0        
if params[:m] == nil       #月を指定しなかった時フラグ=１
  @month_nil_flag = 1
end
tuki = month_hantei(params[:m].to_i)    #月をtukiにセット


#反転表示が必要な場合(今日の日付が含まれている)　フラグ=1
@today_hanntenn_flag = 0
if seireki == @d.year && tuki == @d.month
  @today_hanntenn_flag = 1
end

#カレンダーの１日の曜日を取得する
yobi_01 = Date.new(seireki,tuki,1).strftime('%a')

#カレンダーの月末の日付を取得する
a = Date.new(seireki,tuki,1).next_month
last_day = (a - 1).day

#カレンダー準備
youbi_space = {}
youbi_space = {Sun: 0, Mon: 1, Tue: 2, Wed: 3, Thu: 4, Fri: 5, Sat: 6}

#カレンダーを表示する
print("      #{tuki}月 #{seireki}\n")
print("日 月 火 水 木 金 土\n")

x = youbi_space[yobi_01.to_sym]
x.times do
  print("   ")
end
(1..last_day).each do |i|
  if x % 7 == 0
    print("\n")
  end
  if i >= 1 && i <= 9
    if @today_hanntenn_flag == 1 && i == @d.mday
      print("\e[7m"+" #{i}"+"\e[0m"+" ") 
    else
      print(" #{i} ")
    end
  else
    if @today_hanntenn_flag == 1 && i == @d.mday
      print("\e[7m"+"#{i}"+"\e[0m"+" ")
    else
      print("#{i} ")
    end
  end
  x += 1
end
