module Dev
  class SessionsController < ApplicationController
    allow_unauthenticated_access

    def create
      user = User.find_by!(email_address: "admin@example.com")
      start_new_session_for user
      redirect_to admin_root_path
    end
  end
end
