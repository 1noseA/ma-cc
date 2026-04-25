class PublicController < ApplicationController
  allow_unauthenticated_access all: true
  before_action :track_visitor

  private

  def track_visitor
    identify_visitor
    record_page_view
  end

  def record_page_view
    @current_visitor.events.create!(
      event_type: "page_view",
      path: request.path,
      occurred_at: Time.current
    )
  end

  def identify_visitor
    token = cookies[:visitor_token]
    @current_visitor = Visitor.find_by(visitor_token: token)

    if @current_visitor
      @current_visitor.update!(last_visited_at: Time.current)
    else
      token = SecureRandom.uuid
      cookies.permanent[:visitor_token] = { value: token, httponly: true }
      @current_visitor = Visitor.create!(
        visitor_token: token,
        first_visited_at: Time.current,
        last_visited_at: Time.current
      )
    end
  end
end
