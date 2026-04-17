---
name: create-issue
description: >
  Create a GitHub Issue from a ticket definition in tasks.md.
  Use this skill whenever the user runs /create-issue with a ticket ID (e.g. /create-issue T05),
  asks to "open an issue for T05", "create a GitHub Issue from the ticket", or wants to
  turn a tasks.md ticket into a trackable GitHub Issue. Always invoke this skill when a
  ticket ID like T01-T12 is mentioned alongside issue creation.
---

# create-issue

GitHub Issue を `tasks.md` のチケット定義から作成するスキル。

## 使い方

```
/create-issue <チケットID>
例: /create-issue T05
```

## 手順

### 1. tasks.md を探す

以下の優先順位でファイルを探す。見つからなければエラーを出して終了。

1. `docs/tasks.md`
2. `tasks.md`（プロジェクトルート）

### 2. チケットを抽出する

`### T05:` のような見出し（`### <ID>:` 形式）を起点に、次の `###` 見出しが来るまでをそのチケットのテキストとして取得する。

チケットIDが存在しなければ「チケット `<ID>` は tasks.md に見当たりません」と表示して終了。

### 3. Issue 本文を組み立てる

抽出したテキストから以下のセクションを対応させて Markdown に整形する。

| tasks.md の見出し | Issue セクション |
|---|---|
| **やること** | `## やること` |
| **テスト観点** | `## テスト観点` |
| **確認方法** | `## 確認方法` |

加えて以下を補う。

- `## 概要` : チケットの目的を1〜2行で要約（tasks.md の記述から引用する。補完は最小限に）
- `## 受け入れ条件` : チケット一覧表（`## 3. チケット一覧`）の「完了の判定」列から取得。なければ tasks.md の確認方法から引用
- `## 依存関係` : チケット一覧表の「依存」列を参照。依存がある場合は `- 依存: T04` のように列挙。なければ「なし」

**補完ルール:**
- tasks.md に記載のない情報を勝手に作らない
- 曖昧・不明瞭な点は `## 確認事項` セクションを追加して記載する
- チケットの記述量が多い（目安: やること 10項目超 or 合計300行超）場合は本文の先頭に `> ⚠️ 分割推奨: このチケットは規模が大きい可能性があります。` を付記する

### 4. タイトルを決める

```
<チケットID>: <tasks.md の見出し名>
例: T05: Visitor モデル + cookie 識別
```

### 5. プレビューを表示する

以下の形式でユーザーに提示する。

---

**タイトル:** `T05: Visitor モデル + cookie 識別`

**本文:**
```markdown
## 概要
...

## やること
...

## 受け入れ条件
...

## テスト観点
...

## 確認方法
...

## 依存関係
...
```

---

### 6. ユーザーの承認を得る

「この내容で Issue を作成しますか？ (yes/no)」と明示的に確認する。

- **yes** → ステップ 7 へ
- **no / 修正依頼** → 修正内容をヒアリングして本文を更新し、再度プレビューを表示する
- ユーザーが何も言わずに次の指示をした場合も作成しない

### 7. `gh issue create` を実行する

```bash
gh issue create \
  --title "<タイトル>" \
  --body "<本文>"
```

**事前確認:**
- `gh auth status` が成功するか確認する。失敗した場合は「`gh` が認証されていません。`gh auth login` を実行してください」と表示して終了。
- `gh` コマンド自体がなければ「`gh` CLI が見つかりません。Issue 本文の生成まで完了しています。」と表示して終了。

### 8. 完了報告

Issue 作成後は以下を表示する。

```
✓ Issue を作成しました
  番号: #<issue番号>
  URL:  <URL>
```
