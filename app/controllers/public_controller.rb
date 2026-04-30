class PublicController < ApplicationController
  allow_unauthenticated_access all: true

  TRACKABLE_CONTROLLERS = %w[home articles].freeze

  before_action :track_visitor

  private

  def track_visitor
    identify_visitor
    touch_last_visited_at
    record_page_view_if_trackable
    recalculate_score_if_event_recorded
    set_current_form
  end

  def identify_visitor
    token = cookies.permanent.signed[:visitor_token] ||= SecureRandom.uuid
    @current_visitor = Visitor.find_or_create_by(visitor_token: token) do |v|
      v.first_visited_at = Time.current
      v.last_visited_at = Time.current
    end
  end

  def touch_last_visited_at
    return if @current_visitor.previously_new_record?

    @current_visitor.update(last_visited_at: Time.current)
  end

  def record_page_view_if_trackable
    return unless trackable_request?

    @recorded_event = @current_visitor.events.create!(
      event_type: "page_view",
      path: request.path,
      occurred_at: Time.current
    )
  end

  def recalculate_score_if_event_recorded
    return unless @recorded_event

    @current_visitor.recalculate_score!
  end

  def set_current_form
    @current_form = Form.includes(:display_rules).find { |f| f.should_display_for?(@current_visitor) }
  end

  def trackable_request?
    TRACKABLE_CONTROLLERS.include?(controller_name)
  end
end
