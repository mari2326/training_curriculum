class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @todays_date = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @todays_date..@todays_date + 6)

    7.times do |x|
      today_plans = []
      plans.each do |plan|
        today_plans.push(plan.plan) if plan.date == @todays_date + x
      end


      wday_num = Date.today.wday + x
      if wday_num >= 7
        wday_num = wday_num -7
      end

     
      days = { month: (@todays_date + x).month, date: (@todays_date+x).day, plans: today_plans, :wday => wdays[wday_num]}

      @week_days.push(days)
    end

  end
end


# 1.Date.today.wday 今日の曜日を数字として表示できる　→　数字を足していけば一週間分の曜日を「数字」として表現できる
# 今日であれば「Date.today.wday」、明日であれば「Date.today.wday＋１」（これを一週間分どう表現するかがネック）

# 2.一週間分の曜日を数字で表現しようとし、足し合わせていくと、６を超えてしまう可能性がある
# →条件文が必要となる。

# 3.配列からの値の取り出し方を利用する
# wdays[0],wdays[1]....

# 数字の部分を変化させる必要がある（変数を使用する）