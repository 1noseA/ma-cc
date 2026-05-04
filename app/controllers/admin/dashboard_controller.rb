module Admin
  # 管理画面のダッシュボード。
  # MVP では「訪問者数・リード数・直近イベント」を表示する予定(docs/design.md §8.5)。
  # T03 時点では認証動作確認のためのプレースホルダとして show アクションのみ用意する。
  class DashboardController < ApplicationController
    def show
      @visitor_count = Visitor.count
      @lead_count    = Lead.count
      @conversion_rate = @visitor_count > 0 ? (@lead_count.to_f / @visitor_count * 100).round(1) : 0
      @recent_events = Event.order(occurred_at: :desc).limit(8).includes(:visitor)
    end
  end
end
