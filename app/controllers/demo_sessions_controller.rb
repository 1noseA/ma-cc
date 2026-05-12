class DemoSessionsController < ApplicationController
  allow_unauthenticated_access

  def create
    user = User.find_or_create_by!(email_address: "admin@example.com") do |u|
      u.password = "password"
    end
    start_new_session_for user
    redirect_to admin_root_path
  end
end
