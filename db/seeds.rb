# マーケティングオートメーション学習用MVP シードデータ
#
# 冪等性: 全レコードを find_or_create_by! で作るので、複数回実行しても増えない。
# 詳細は docs/tasks.md §5 を参照。

# 管理者ユーザー(T03)
User.find_or_create_by!(email_address: "admin@example.com") do |u|
  u.password = "password"
end

# サンプル記事 5件(T04)
5.times do |i|
  Article.find_or_create_by!(title: "サンプル記事 #{i + 1}") do |a|
    a.body      = "これはサンプル記事 #{i + 1} の本文です。\n\n訪問者の行動記録と条件付きフォーム表示を学ぶためのダミーコンテンツです。"
    a.published = true
  end
end

puts "Seed completed."
