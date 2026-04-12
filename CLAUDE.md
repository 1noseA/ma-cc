# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## このリポジトリは何か

Ruby 3.4.9 / Rails 8.1.3 を使った**学習目的の簡易マーケティングオートメーション(MA)ツール**。匿名訪問者の行動を記録し、条件を満たしたらフォームを出して、送信によってリード化する、という MA の本質的な流れを最小構成で通すことを目的にしている。外部SaaS/メール配信/CRM連携/バックグラウンドジョブは一切使わない、ローカル1人開発前提のアプリ。

設計・要件・実装順序の3つが独立したドキュメントに分かれているので、コードに触る前に必ず該当セクションに目を通すこと。

- `docs/requirements.md` — 何を作るか(MVP機能6つ、非MVPの除外理由、動作確認シナリオ)
- `docs/design.md` — どう作るか(ERD / 集約 / classDiagram / モデル・コントローラ責務 / スコア計算・表示ルール判定の責務分担)
- `docs/tasks.md` — どの順序で作るか(T01〜T12 のチケット、Phase 0〜6)

この3本は相互参照前提で書かれており、**ドメインモデル・ERD・classDiagram の整合性が崩れると全体が成立しない**。ドメインを触る変更をした時は `docs/design.md` の §4 ERD / §5 集約 / §5.5 関連 / §6 classDiagram / §7 モデル / §8 コントローラ を同期させること。

## 技術スタックと制約

| 項目 | 値 |
|---|---|
| Ruby | 3.4.9(`.ruby-version` に記載) |
| Rails | 8.1.3 |
| DB | SQLite(Rails 8 デフォルト。`storage/*.sqlite3`) |
| CSS | TailwindCSS(`tailwindcss-rails`) |
| 認証 | Rails 8 標準 `bin/rails generate authentication` |
| テスト | RSpec(`rspec-rails`)※ T02 で導入予定 |
| JS | Rails 標準の Turbo の範囲のみ。SPA/フロントJSフレームワーク禁止 |
| 外部連携 | 使用しない(メール配信・CRM・外部API すべて禁止) |
| バックグラウンドジョブ | 使用しない(同期処理のみ) |

「学習用・1人利用・ローカル環境のみ」が大前提。本番運用・複数テナント・パフォーマンス最適化を想定した作り込みは明示的にスコープ外。パフォーマンス最適化の余地は `docs/design.md` §10.2 に将来検討項目として記述されている。

## 実装進捗

| フェーズ | 状態 | 含まれるチケット |
|---|---|---|
| Phase 0: 環境構築 | 🟡 T01 完了 / T02, T03 未着手 | T01, T02, T03 |
| Phase 1〜6 | ⬜ 未着手 | T04〜T12 |

- **T01 完了済**: `rails new . -d sqlite3 --css tailwind --skip-test --skip-git` 実行済み。`.ruby-version` = 3.4.9、`Gemfile` = `~> 8.1.3`、`bin/rails about` と DB 準備確認済み
- **T02 次**: RSpec 導入(`rspec-rails`, 任意で `factory_bot_rails` / `capybara`)。`--skip-test` で Minitest は入っていないので、`spec/` と `rails_helper.rb` はこのタイミングで生成する
- **T03 次**: `bin/rails generate authentication` で Rails 8 標準認証を導入

未着手チケットを着手する時は、必ず該当チケットの「やること / テスト観点 / 確認方法」を `docs/tasks.md` §4 で読み、前提依存チケットが終わっていることを確認してから進めること。

## よく使うコマンド

```bash
# 開発サーバ起動(Rails + Tailwind のウォッチャを同時起動)
bin/dev

# DB 初期化とマイグレーション
bin/rails db:prepare              # 初回・既存DB利用
bin/rails db:reset                # 完全リセットしてから再作成
bin/rails db:seed                 # seedデータ投入(T11 で本格整備)

# テスト(T02 以降で有効)
bundle exec rspec                                  # 全spec
bundle exec rspec spec/models/visitor_spec.rb      # 単一ファイル
bundle exec rspec spec/models/visitor_spec.rb:42   # 単一example
bundle exec rspec spec/system                      # システムスペックのみ

# 対話確認
bin/rails console
bin/rails routes
bin/rails about
```

MVP の**完了基準**は「`bin/rails db:seed` 直後の状態から `docs/requirements.md` §6.2 の操作手順をブラウザだけで再現でき、`bundle exec rspec spec/system` がその再現を自動化した spec で緑になること」(`docs/tasks.md` §1)。

## アーキテクチャの勘所

### 全体構造

単一の Rails モノリスで、**公開側と管理側を名前空間で分離**する1アプリ構成。

- 公開側は `PublicController` を継承。`before_action :track_visitor` で「訪問者識別 → 最終訪問時刻更新 → page_view 記録 → スコア再計算」を1箇所に集約する
- 管理側は `Admin::ApplicationController` を継承。`before_action :require_authentication` で全画面を保護する

公開コントローラとビューでスコア計算・表示ルール判定・トラッキング処理を分散させないこと。詳細は `docs/design.md` §1、§8。

### ドメインモデル(集約)

| 集約ルート | 子 | 役割 |
|---|---|---|
| **Visitor** | Event, FormSubmission | 匿名訪問者の継続観察と**行動履歴の主体**。ページ閲覧もフォーム送信もすべて Visitor 配下の履歴として扱う |
| **Form** | DisplayRule | フォーム定義と表示条件の一体運用 |
| **Lead** | (子なし) | 「匿名→顕在化」の結果を表す独立集約。連絡先のみ保持し、履歴は持たない |
| **Article** | (子なし) | 閲覧対象コンテンツ |

**意図的な非自明な決定**(実装時に崩さないこと):

- **Lead と FormSubmission の間に直接の関連を張らない**。リードの送信履歴は `lead.visitor.form_submissions` で辿る。これにより Visitor と Lead で履歴が分裂する問題を構造的に防ぐ。`form_submissions` テーブルに `lead_id` カラムを追加してはいけない
- **Event テーブルは `page_view` と `form_submit` を統合**して単一テーブルにしている。別テーブルに分けない
- **Visitor と Lead は別エンティティとして残す**。「同一の人」と解釈して統合しない。「匿名→顕在化」という状態遷移を学習用として分かりやすく見せるため
- **フォーム項目は「メール + 氏名」固定**。動的フォーム項目(`FormField` 相当)は MVP スコープ外

詳細は `docs/design.md` §5、§6。

### 責務分担の鉄則

以下の3点は実装時に崩してはいけない。これが崩れるとドキュメント全体の一貫性が壊れる。

1. **スコア計算は `ScoreCalculator`(PORO)に集約**する。`Visitor#recalculate_score!` と `ScoreCalculator.new(visitor).call` を経由する以外の方法で `score` を算出・更新しない。MVP では**全履歴再計算方式**(差分加算ではない)を採用しており、これは意図的な選択(`docs/design.md` §10.1)
2. **表示ルール判定は `DisplayRule#matches?` と `Form#should_display_for?`** に集約する。コントローラやビューでイベント数を直接数えない。新しいルール種別を追加する時は `DisplayRule#matches?` の `case` 句に when を追加するだけで済ませる
3. **トラッキング処理は `PublicController#track_visitor` 1箇所**に集約する。これ以外の場所で `Visitor` や `Event` を生成しない。`track_visitor` 自体は4つの private メソッド(`identify_visitor` / `touch_last_visited_at` / `record_page_view_if_trackable` / `recalculate_score_if_event_recorded`)で構成された順序メソッドに留める

### trackable path のホワイトリスト

`page_view` を記録するのは**関心度を測るのに意味がある公開ページだけ**。`PublicController::TRACKABLE_CONTROLLERS` という定数ホワイトリスト(controller 名のリスト)で管理する(`docs/design.md` §8.1.2)。

- 計測対象: `/`(home), `/articles`, `/articles/:id`
- 非計測: `/forms/:id/thanks`(送信完了), `/session/*`(認証), `/admin/*`(そもそも `PublicController` を継承しない)

新しい計測対象ページを追加する時は `TRACKABLE_CONTROLLERS` に controller 名を追記する。ブラックリスト方式にしない。

### URL 設計

- 公開側: `root "home#show"`, `resources :articles, only: %i[index show]`, `resources :forms do member { get :thanks }; resources :submissions, only: %i[create], controller: "form_submissions" end`
- 認証: Rails 8 標準の `resource :session`。要件書が言う「/admin/login」は実際には `/session/new`
- 管理側: `namespace :admin` 配下に `visitors`, `leads`, `forms`(+ `display_rules` をネスト), `articles`
- **訪問者一覧とリード一覧は別ページ**として実装する(要件上の必須事項。`docs/requirements.md` §8.2)

## 実装時の注意

### MVP に非MVP機能を混ぜない

`docs/requirements.md` §5 の非MVP一覧は**意図的に除外**した機能リストである。AND/OR 複合条件、ステップメール、動的フォーム項目、CRM連携、バックグラウンド集計、AI予測 などを「ついでに」入れない。入れたくなった時は要件書と設計書の更新から始めること。

### MVPで「あえてまとめた判断」を無意識に崩さない

`docs/design.md` §5.6 に「あえて統合/分離した判断」が記されている。Event の種別分割、フォーム項目の動的化、Visitor と Lead の統合、DisplayRule の複合条件化 などは、学習用として「今は崩さない」ことを明示した決定事項。崩したくなったら設計書の該当箇所を先に更新すること。

### `ScoreCalculator` の外部I/Fを変えない

将来 `ScoreCalculator` を差分加算方式・集計キャッシュ・非同期化(ActiveJob)のいずれかに移行する余地を保つため、呼び出し側は常に `ScoreCalculator.new(visitor).call` の形だけを使う(`docs/design.md` §10.2)。`Visitor#recalculate_score!` とコントローラは、この呼び出しを包むだけの薄い層に留める。

### 実装順序は `docs/tasks.md` の Phase 0〜6 に従う

チケットには依存関係がある(例: T09 表示ルールは T08 Form/Lead の後、T10 スコア順は T09 の後)。順番を飛ばすとテスト観点が成立しなくなるので、依存を先に終わらせてから着手すること。
