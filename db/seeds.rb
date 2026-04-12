# マーケティングオートメーション学習用MVP シードデータ
#
# 冪等性: 全レコードを find_or_create_by! で作るので、複数回実行しても増えない。
# 詳細は docs/tasks.md §5 を参照。

# 管理者ユーザー(T03)
User.find_or_create_by!(email_address: "admin@example.com") do |u|
  u.password = "password"
end

puts "Seed completed."
