module Admin
  # 管理画面共通のベースコントローラ。
  #
  # 認証は ::ApplicationController で include 済みの Authentication モジュールに委譲する。
  # ここでは管理側特有の共通処理(将来のレイアウト指定や権限チェック)を足す拡張ポイントのみ持つ。
  # docs/design.md §8.4 参照。
  class ApplicationController < ::ApplicationController
  end
end
