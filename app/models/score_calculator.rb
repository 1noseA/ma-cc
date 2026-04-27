class ScoreCalculator
  PAGE_VIEW_POINT   = 1
  FORM_SUBMIT_POINT = 3
  PATH_BONUS = {}.freeze

  def initialize(visitor)
    @visitor = visitor
  end

  def call
    @visitor.events.sum { |event| points_for(event) }
  end

  private

  def points_for(event)
    base_points(event) + path_bonus(event)
  end

  def base_points(event)
    case event.event_type
    when "page_view"   then PAGE_VIEW_POINT
    when "form_submit" then FORM_SUBMIT_POINT
    else 0
    end
  end

  def path_bonus(event)
    PATH_BONUS[event.path].to_i
  end
end
