---
name: browser-test
description: Toolkit for interacting with and testing local web applications using Playwright. Supports verifying frontend functionality, debugging UI behavior, capturing browser screenshots, and viewing browser logs.
---

# Web Application Testing

To test local web applications, write native Python Playwright scripts.

**Helper Scripts Available**:
- `scripts/with_server.py` in the official plugin - Manages server lifecycle (supports multiple servers)

**Always run scripts with `--help` first** to see usage.

## このプロジェクトの規約

### サーバー起動

Rails アプリは `bin/rails server` で起動する（`bin/dev` は TTY が必要なため不可）。
`with_server.py` のパスは以下を使う:

```bash
python3 ~/.claude/plugins/cache/anthropic-agent-skills/example-skills/2c7ec5e78b8e/skills/webapp-testing/scripts/with_server.py \
  --server "bin/rails server" --port 3000 -- python3 /tmp/your_script.py
```

### スクリーンショットの保存先

**必ず** `tmp/screenshots/` に保存する。ファイル名は他のスクリーンショットに合わせて以下の命名規則に従う:

```
tmp/screenshots/<チケット番号>_<連番>_<内容>.png
例: tmp/screenshots/t09_01_before_threshold.png
    tmp/screenshots/t09_02_after_threshold.png
```

スクリプト内では絶対パスで指定する:

```python
import os
PROJECT_ROOT = os.path.dirname(os.path.abspath(__file__))  # スクリプトをプロジェクトルートに置く場合
SCREENSHOT_DIR = "/Users/nose/Desktop/development/ma-cc/tmp/screenshots"

page.screenshot(path=f"{SCREENSHOT_DIR}/t09_01_before_threshold.png", full_page=True)
```

### Stimulus コントローラの待ち方

このプロジェクトは Stimulus を使っており、`connect()` 内で遅延処理（`setTimeout`）が走ることがある。
`networkidle` 後に追加で待機が必要な場合は `page.wait_for_timeout(1200)` を入れる。

### サーバー起動前の DB ウォームアップ

Playwright スクリプト内でサーバー起動待ちをする場合、**別ブラウザコンテキスト**を使う。
同じコンテキストで待機リクエストを送るとページビューが記録されてしまい、テスト結果が狂う。

```python
# サーバー起動待ち用（別コンテキスト）
warmup = browser.new_context()
warmup_page = warmup.new_page()
for _ in range(10):
    try:
        warmup_page.goto("http://localhost:3000", timeout=3000)
        break
    except Exception:
        time.sleep(1)
warmup.close()
# ここから本番コンテキストを作る
```

---

## Decision Tree: Choosing Your Approach

```
User task → Is it static HTML?
    ├─ Yes → Read HTML file directly to identify selectors
    │         ├─ Success → Write Playwright script using selectors
    │         └─ Fails/Incomplete → Treat as dynamic (below)
    │
    └─ No (dynamic webapp) → Is the server already running?
        ├─ No → Use with_server.py (上記パスを参照)
        └─ Yes → Reconnaissance-then-action:
            1. Navigate and wait for networkidle
            2. Take screenshot or inspect DOM
            3. Identify selectors from rendered state
            4. Execute actions with discovered selectors
```

### Turbo フォームの送信

このプロジェクトは Turbo (Rails 8 デフォルト) を使っており、フォーム送信が非同期になる。
`page.click("input[type='submit']")` や `press("Enter")` は Turbo フォームを送信できないことがある。

**正しいパターン**:

```python
# Turbo フォームの送信は expect_navigation + requestSubmit() を使う
with page.expect_navigation():
    page.evaluate("document.querySelector('form').requestSubmit()")
page.wait_for_load_state("networkidle")
```

ダイアログ内のフォームを送信する場合は `dialog[open] form` を使う:

```python
with page.expect_navigation():
    page.evaluate("document.querySelector('dialog[open] form').requestSubmit()")
```

---

## Decision Tree: Choosing Your Approach

```
User task → Is it static HTML?
    ├─ Yes → Read HTML file directly to identify selectors
    │         ├─ Success → Write Playwright script using selectors
    │         └─ Fails/Incomplete → Treat as dynamic (below)
    │
    └─ No (dynamic webapp) → Is the server already running?
        ├─ No → Use with_server.py (上記パスを参照)
        └─ Yes → Reconnaissance-then-action:
            1. Navigate and wait for networkidle
            2. Take screenshot or inspect DOM
            3. Identify selectors from rendered state
            4. Execute actions with discovered selectors
```

## Best Practices

- Use `sync_playwright()` for synchronous scripts
- Always close the browser when done
- Use descriptive selectors: `text=`, `role=`, CSS selectors, or IDs
- Add appropriate waits: `page.wait_for_selector()` or `page.wait_for_timeout()`
- `dialog[open]` で開いているモーダルの存在を確認する（`dialog` だけでは DOM にあるだけで非表示の場合がある）
- Turbo フォームの送信には `expect_navigation + requestSubmit()` を使う（上記参照）
