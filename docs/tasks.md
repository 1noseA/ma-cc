# マーケティングオートメーション学習用MVP タスクリスト

> 本書は [`docs/requirements.md`](./requirements.md) と [`docs/design.md`](./design.md) で定めた仕様を、**実装作業に落とし込むためのタスクリスト** である。
>
> 関連ドキュメント:
> - 要件定義: [`docs/requirements.md`](./requirements.md)
> - 設計: [`docs/design.md`](./design.md)

---

## 目次

1. MVP完了の定義
2. 開発フェーズ概観
3. チケット一覧 (実装順)
4. 各チケット詳細
5. シードデータ作成手順
6. MVP完了チェックリスト

---

## 1. MVP完了の定義

以下のすべてを満たした時点で MVP完成とする。

1. `bin/rails db:seed` を実行した直後の状態から、要件定義書 §6.2 の操作手順をブラウザだけで再現できる
2. 公開LP → 記事閲覧 → 条件達成 → フォーム表示 → 送信 → リード化、までが1セッションで通る
3. 管理画面の **訪問者一覧** と **リード一覧** が **別ページ** として存在し、リード一覧はスコア降順で並ぶ
4. リード詳細画面で「リード化前の行動履歴」が同じ画面に表示される
5. 管理画面が未ログインで開けない (ログイン画面にリダイレクトされる)
6. RSpec のシステムスペックで上記シナリオを自動再現するテストが1本緑になっている

---

## 2. 開発フェーズ概観

| フェーズ | 目的 | 含まれるチケット |
|---|---|---|
| Phase 0: 環境構築 | プロジェクト雛形の準備 | T01, T02, T03 |
| Phase 1: 公開コンテンツの土台 | 訪問対象を作る | T04 |
| Phase 2: トラッキング基盤 | 訪問者識別と行動記録 | T05, T06 |
| Phase 3: フォームとリード化 | 接点とコンバージョン | T07, T08 |
| Phase 4: 条件付き表示 | MAらしい振る舞い | T09 |
| Phase 5: スコアリング | 関心度の可視化 | T10 |
| Phase 6: 仕上げ | 動作確認の自動化 | T11, T12 |

各フェーズは前のフェーズに依存する。フェーズ内のチケットは原則上から順に進める。

---

## 3. チケット一覧 (実装順)

| ID | 件名 | フェーズ | 依存 | 完了の判定 |
|---|---|---|---|---|
| T01 | プロジェクト生成 (Rails 8.1.3 + SQLite + Tailwind) | Phase 0 | - | `bin/dev` で Welcome 画面が出る |
| T02 | RSpec 導入 | Phase 0 | T01 | `bundle exec rspec` がサンプルspecで緑 |
| T03 | 認証導入 (`bin/rails generate authentication`) | Phase 0 | T02 | seed の管理者でログインできる |
| T04 | `Article` モデル + 公開LP + 記事一覧 + 記事詳細 | Phase 1 | T01 | `/`, `/articles`, `/articles/:id` がブラウザで見える |
| T05 | `Visitor` モデル + cookie 識別 | Phase 2 | T04 | DevTools で cookie が確認でき、DBに `Visitor` が増える |
| T06 | `Event` モデル + ページ閲覧記録 + 管理画面の訪問者一覧/詳細 | Phase 2 | T05 | 自分のブラウザ操作が管理画面で時系列表示される |
| T07 | `Form` モデル + 公開ページに常時表示でフォーム埋め込み | Phase 3 | T06 | フォームを送信できる |
| T08 | `FormSubmission` + `Lead` モデル + リード化 + リード一覧/詳細 | Phase 3 | T07 | 送信するとリード一覧に登場 |
| T09 | `DisplayRule` モデル + 表示ルール判定で条件付き表示に切り替え | Phase 4 | T08 | 閾値未満では出ず、超えたら出る |
| T10 | `ScoreCalculator` 導入 + リード一覧のスコア降順 | Phase 5 | T09 | 行動が多い訪問者ほど上位 |
| T11 | seedデータ整備 | Phase 6 | T10 | `bin/rails db:seed` 直後に §6 シナリオを再現できる |
| T12 | システムスペックでシナリオ自動化 | Phase 6 | T11 | `bundle exec rspec spec/system` が緑 |

---

## 4. 各チケット詳細

各チケットは「やること」「テスト観点」「確認方法」の3点を最低限明示する。テストは観点だけ書き、テスト粒度は機能の重要度で調整する(モデル・リクエスト・システムを目的別に使い分ける)。

---

### T01: プロジェクト生成

**やること**
- `rails new ma-cc -d sqlite3 --css tailwind --skip-test` 実行
- Ruby バージョン (`.ruby-version` = `3.4.9`) 設定
- Rails バージョン (Gemfile = `8.1.3`) 確認
- `bin/dev` で起動

**テスト観点**
- (なし。生成物の起動確認のみ)

**確認方法**
- `bin/dev` 起動 → ブラウザで `http://localhost:3000` を開く → Rails のWelcomeページが見える

---

### T02: RSpec 導入

**やること**
- `bundle add rspec-rails --group "development, test"`
- `bin/rails generate rspec:install`
- (任意) `factory_bot_rails` `capybara` を入れる
- `rails_helper.rb` の基本設定確認

**テスト観点**
- RSpec が起動すること
- ジェネレータがspecを生成すること

**確認方法**
- `bundle exec rspec` を実行 → 0例失敗で緑

---

### T03: 認証導入

**やること**
- `bin/rails generate authentication`
- 生成された `users` / `sessions` テーブルの migration を実行
- `db:seed` で管理者ユーザー1名を投入
- `Admin::ApplicationController` の雛形を作り `Authentication` モジュールを include
- `routes.rb` に `namespace :admin` を追加(中身は後続チケットで埋める)

**テスト観点**
- 未認証で `/admin` にアクセス → ログイン画面にリダイレクトされる (リクエストスペック)
- 認証済みで `/admin` にアクセス → 200 が返る

**確認方法**
- ブラウザで `/admin` にアクセス → ログイン画面に飛ぶ
- ログイン後に再度 `/admin` を開ける

---

### T04: Article モデル + 公開LP + 記事一覧 + 記事詳細

**やること**
- `bin/rails g model Article title:string body:text published:boolean`
- `bin/rails g controller Home show` (root に割り当て)
- `bin/rails g controller Articles index show`
- `routes.rb` に `root "home#show"` と `resources :articles, only: %i[index show]`
- ビューは Tailwind で最小実装(タイトル・本文の表示だけ)
- seed に Article 5件を投入

**テスト観点**
- モデルスペック: title / body のバリデーション
- リクエストスペック: `GET /` `GET /articles` `GET /articles/:id` が 200

**確認方法**
- ブラウザで `/`, `/articles`, `/articles/:id` を表示
- 5件の記事が一覧に並ぶ

---

### T05: Visitor モデル + cookie 識別

**やること**
- `bin/rails g model Visitor visitor_token:string first_visited_at:datetime last_visited_at:datetime score:integer`
- migration で `visitor_token` に unique index、`score` に index
- `Visitor` モデルに validations を追加 (`presence`, `uniqueness`)
- `PublicController` を新規作成し、`before_action :track_visitor` を実装(まずは Visitor の引き当て/作成と `last_visited_at` の更新まで)
- `HomeController` `ArticlesController` を `PublicController` 継承に変更

**テスト観点**
- リクエストスペック: 初回 GET / で Visitor が1件作成される
- リクエストスペック: 同じ cookie で2回目 GET すると Visitor は増えない
- リクエストスペック: cookie をクリアして再アクセスすると別 Visitor になる

**確認方法**
- ブラウザDevTools → Application → Cookies で `visitor_token` を確認
- `bin/rails console` で `Visitor.count` が増えること
- プライベートウィンドウで別 Visitor になること

---

### T06: Event モデル + ページ閲覧記録 + 管理画面の訪問者一覧/詳細

**やること**
- `bin/rails g model Event visitor:references event_type:string path:string occurred_at:datetime`
- migration でインデックス追加 (`visitor_id`, `(visitor_id, occurred_at)`, `event_type`)
- `Event` モデルに validations と scope (`page_views`, `form_submits`)
- `Visitor#page_view_count` を追加
- `PublicController#track_visitor` で `events.create!(event_type: "page_view", path: request.path, occurred_at: Time.current)` を追加
- `Admin::VisitorsController#index` `show` を作成(訪問者一覧と詳細)
- 訪問者詳細では行動履歴を時系列表示

**テスト観点**
- モデルスペック: Event のバリデーション
- リクエストスペック: GET /articles/1 → Event が1件 page_view で作られる
- システムスペック寄り: 訪問者詳細画面に行動履歴が表示される

**確認方法**
- 公開ページを複数閲覧 → 管理画面の訪問者一覧に1件表示
- 訪問者詳細を開くと閲覧したパスが時系列で並ぶ

---

### T07: Form モデル + 公開ページに常時表示でフォーム埋め込み

**やること**
- `bin/rails g model Form name:string description:string success_message:string`
- `Form` モデルに validations を追加 (まだ `should_display_for?` は実装しない、または常に true を返す仮実装)
- `forms_controller.rb` (公開側) を作り、`thanks` アクションを追加
- `routes.rb` に `resources :forms, only: [] do member { get :thanks } end`
- `shared/_form_for_visitor.html.erb` を作成し、HomeとArticles の show に `<%= render "shared/form_for_visitor" %>` を入れる
- まずは **無条件で表示**

**テスト観点**
- モデルスペック: Form のバリデーション
- システムスペック: 記事ページにフォームが見えること

**確認方法**
- 公開ページに常にフォームが表示される
- フォーム送信は次のチケットで対応するため、まだ送信できなくてよい

---

### T08: FormSubmission + Lead モデル + リード化 + リード一覧/詳細

**やること**
- `bin/rails g model FormSubmission form:references visitor:references email:string name:string submitted_at:datetime`
- `bin/rails g model Lead visitor:references email:string name:string first_converted_at:datetime`
- migration で `leads.visitor_id` に unique index
- 各モデルに validations を追加
- `form_submissions_controller.rb#create` を実装
  1. `FormSubmission` 作成
  2. `Lead.find_or_create_by(visitor_id: ...)` でリード化
  3. `Event(form_submit)` を記録
  4. `/forms/:id/thanks` にリダイレクト
- `Admin::LeadsController#index` `show` を作成 (まずは作成順で表示。スコア順は T10)
- リード詳細では「行動履歴」「フォーム送信履歴」も表示

**テスト観点**
- モデルスペック: Lead の visitor_id ユニーク制約
- リクエストスペック: POST /forms/:id/submissions で Lead と FormSubmission と Event が作られる
- リクエストスペック: 同じ Visitor が2回送信しても Lead は1件のまま
- システムスペック寄り: 訪問者一覧で「リード化済」が判別できる

**確認方法**
- フォームを送信 → サンクスへ
- 管理画面のリード一覧にレコードが現れる
- リード詳細で行動履歴が見える

---

### T09: DisplayRule モデル + 条件付き表示

**やること**
- `bin/rails g model DisplayRule form:references rule_type:string threshold:integer enabled:boolean`
- migration で `enabled` の default: true、`form_id` に index
- `DisplayRule#matches?(visitor)` を実装 (`visit_count_gte` のみ)
- `Form#should_display_for?(visitor)` を実装 (display_rules の OR)
- `PublicController` で「表示すべきフォーム」を1件選び `@current_form` にセット
- `shared/_form_for_visitor.html.erb` を `if @current_form` で出し分け
- `Admin::DisplayRulesController` の CRUD (forms にネスト)

**テスト観点**
- モデルスペック: 閾値の境界値テスト (threshold=3 のとき、page_view 2件→false、3件→true)
- モデルスペック: enabled=false のとき false
- リクエストスペック: 条件未達ではフォームが描画されない、達成後は描画される

**確認方法**
- 1〜2ページ閲覧してもフォームが出ない
- 3ページ目以降でフォームが出る
- 表示ルールを無効化すると出なくなる

---

### T10: ScoreCalculator 導入 + リード一覧のスコア降順

**やること**
- `app/models/score_calculator.rb` を作成 (PORO)
- 加算ルール: page_view +1, form_submit +3, PATH_BONUS は空Hash
- `Visitor#recalculate_score!` を ScoreCalculator 呼び出しに変更
- `PublicController#track_visitor` の最後に `@current_visitor.recalculate_score!` を追加
- `FormSubmissionsController#create` の最後にも `recalculate_score!` を追加
- `Admin::LeadsController#index` を `Lead.joins(:visitor).order("visitors.score DESC").includes(:visitor)` に変更

**テスト観点**
- モデルスペック (ScoreCalculator):
  - page_view 0件 → 0pt
  - page_view 3件 → 3pt
  - page_view 3件 + form_submit 1件 → 6pt
  - PATH_BONUS が定義されている時の挙動 (将来拡張用に1ケース)
- リクエストスペック: フォーム送信後に visitor.score が +3 される
- システムスペック寄り: リード一覧がスコア降順

**確認方法**
- 複数ブラウザで操作回数を変えて、リード一覧のスコア順を確認

---

### T11: seedデータ整備

**やること**
- `db/seeds.rb` を整備 (詳細は §5 シードデータ作成手順)
- `bin/rails db:seed` で冪等に投入できることを確認
- `bin/rails db:seed:replant` で再投入可能なことを確認

**テスト観点**
- (基本的に手動確認。必要に応じて seeds に対するテストを書いてもよい)

**確認方法**
- DB をリセット (`bin/rails db:reset`) して `bin/rails db:seed`
- 管理者ログイン → サンプル記事5件・フォーム1件・表示ルール1件が見える
- 公開LPで要件§6.2 のシナリオを再現できる

---

### T12: システムスペックでシナリオ自動化

**やること**
- `spec/system/` にシナリオspecを追加
- 要件定義書 §6.2 の操作手順を Capybara で自動再現
  1. ルートにアクセス
  2. 記事を3つ閲覧
  3. 4ページ目でフォームが表示されることを確認
  4. フォーム送信
  5. 管理者ログイン
  6. リード一覧で1件あることを確認

**テスト観点**
- 公開→閲覧→表示→送信→管理画面確認、を一気通貫で確認
- リード詳細で行動履歴が表示されること
- リード一覧がスコア順であること

**確認方法**
- `bundle exec rspec spec/system` が緑

---

## 5. シードデータ作成手順

`db/seeds.rb` の内容(目安)。

```ruby
# 管理者ユーザー
User.find_or_create_by!(email_address: "admin@example.com") do |u|
  u.password = "password"
end

# サンプル記事 5件
5.times do |i|
  Article.find_or_create_by!(title: "サンプル記事 #{i + 1}") do |a|
    a.body      = "これはサンプル記事 #{i + 1} の本文です。"
    a.published = true
  end
end

# 問い合わせフォーム
form = Form.find_or_create_by!(name: "問い合わせフォーム") do |f|
  f.description     = "お気軽にお問い合わせください"
  f.success_message = "送信ありがとうございました"
end

# 表示ルール: 累計3回以上ページ閲覧したら表示
DisplayRule.find_or_create_by!(form: form, rule_type: "visit_count_gte") do |r|
  r.threshold = 3
  r.enabled   = true
end

puts "Seed completed."
```

### 5.1 投入手順

1. `bin/rails db:reset` (or `db:drop && db:create && db:migrate`)
2. `bin/rails db:seed`
3. `bin/rails console` で件数確認
   - `User.count` → 1
   - `Article.count` → 5
   - `Form.count` → 1
   - `DisplayRule.count` → 1

### 5.2 冪等性

- 全レコードを `find_or_create_by!` で作る
- `bin/rails db:seed` を複数回実行しても件数が増えないこと

---

## 6. MVP完了チェックリスト

実装完了前に以下を1つずつ確認する。

### 6.1 機能チェック

- [ ] 公開LPに訪問すると cookie が発行される
- [ ] 同じブラウザで再アクセスしても Visitor は増えない
- [ ] プライベートウィンドウで別 Visitor になる
- [ ] 記事閲覧で Event が時系列に記録される
- [ ] 累計3回未満ではフォームが表示されない
- [ ] 累計3回以上でフォームが表示される
- [ ] フォーム送信でリードが作成される
- [ ] リード化前の行動履歴がリード詳細に表示される
- [ ] 同じ訪問者が2回送信してもリードは1件のまま
- [ ] 管理画面が未認証で開けない (ログイン画面にリダイレクト)
- [ ] 管理画面の訪問者一覧とリード一覧が別ページ
- [ ] リード一覧がスコア降順で並ぶ
- [ ] スコアの加算が page_view +1 / form_submit +3 になっている

### 6.2 設計品質チェック

- [ ] スコア計算が `ScoreCalculator` に集約されている (Visitor / Controller に直接計算式がない)
- [ ] 表示ルール判定が `DisplayRule#matches?` に集約されている
- [ ] トラッキング処理が `PublicController#track_visitor` に集約されている
- [ ] Visitor / Lead が別エンティティとして残っている
- [ ] Form / DisplayRule の関連が `forms` ネストルーティングに反映されている

### 6.3 動作確認の自動化チェック

- [ ] `bundle exec rspec` で全テストが緑
- [ ] `spec/system/` のシナリオスペックが要件§6.2 を再現している
- [ ] `bin/rails db:reset && bin/rails db:seed` 後に手動シナリオが通る

すべてチェックが付いた時点で **MVP完成** とする。
